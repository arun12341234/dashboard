#encoding: utf-8

require 'csv'
require 'socket'
require 'fileutils'
require 'pp'
require 'date'
require 'date'
require 'mysql2'



client = Mysql2::Client.new(
host: 'localhost',
username: 'root',
password: 'Password@123',
database: 'test_db'
)




#
# Global Variables
##########################

# Debug Level: 0 (no log), 1(Low), 2(High)
$debug = 0

# Threshold (%) of enrolment status
CRIT=30
WARN=50

$crit = 0
$warn = 0
$norm = 0

# Max length of Title
MAXTITLE=20

## CSV Data files
workdir = Dir.pwd
if ( Socket.gethostname != 'blzotac' )
  # Docker for Live
    DATADIR = '/dashing/data/'
    ERRDIR = '/dashing/data/errdata/'
else
  # Development Environment
	DATADIR = workdir+'/data/'
	ERRDIR = workdir++'/errdata/'
end

STATDATA = workdir+'/data/'+'ksa-status.csv'
print STATDATA
$total_enrolment = Hash.new
$my_csv = Array.new

#
# End of Global Variables
###########################################

# 소수점 첫 째자리 반올림을 포함한 Percentage 계산
# See https://stackoverflow.com/questions/3668345/calculate-percentage-in-ruby
class Numeric
    def percent_of(n)
        (self.to_f / n.to_f * 1000.0 + 5).floor / 10
    end
end

# CSV 파일 encoding 확인
def detect_encoding(file_with_fullpath)
	# charset 정보 획득
	enc = `file -i #{file_with_fullpath}`.strip.split('charset=').last

	# UTF-8 with BOM 여부 확인
	case enc
	when "utf-8"
		# refer to https://stackoverflow.com/questions/44171895/ruby-check-for-byte-order-marker
		is_bom = File.open(file_with_fullpath) { |f| f.read(3).bytes == [239, 187, 191] }
		if is_bom
			enc = 'bom|utf-8'
		else
			enc = 'utf-8'
		end
	when "iso-8859-1"
		enc = "euc-kr:utf-8"
	end

	return enc
end

# Sort
def sort_csv_data
	sort_order = { "KS" => 1, "공개" => 2, "사내" => 3, "기타" => 4 }

	rows = Array.new
	h = Hash.new

	csv_encoding = detect_encoding(STATDATA)
	puts "Encoding of CSV file: %s" % csv_encoding

	CSV.foreach(STATDATA, :encoding => csv_encoding, :headers => true) do |row|
		puts $INPUT_LINE_NUMBER, row.pretty_inspect if ( $debug >= 2 )

		# Data 가 없으면 다음 row 진행
	  next if row["과정명"] == nil

		# CSV Header 를 Key 로 가지는 Hash 로 변환
		h = row.to_h

		# Sort 를 위한 "order" 추가
		h["order"] = sort_order[row["훈련구분"]]
		rows << h
	end

	# Sort 결과 저장
	$my_csv = rows.sort_by { |row| row["order"].to_i  }
	puts $my_csv.pretty_inspect if $debug >= 1

end

# Read the Lectures/Enrolment status from $my_csv
def read_lecture_stat

	$enrolment_status = Array.new
	lect_total = 0

	$my_csv.each do |row|
		title = row["과정명"]
		if title.length > MAXTITLE
			puts "Title length: %d" % title.length if $debug>=2
			title = title[0..MAXTITLE].strip
		else
			title = title.strip
		end

		# 수강 접수 중인 강의가 있는지 여부 확인

		# CSV Data Type
		#		0: 수강 접수 가능한 강의 있음
		#		1: 개설 강의 없음

		# Fields:
		#		c1: 과정명
		#		c2: 훈련 구분
		#		c3: 과정담당자
		#		c4: 개최지역본부
		#		c5: 학습기간
		#		c6: 정원
		#		c7: 접수 (현황)
		#		c8: 정원 외

		puts "접수: %d / 정원: %d / 정원 외: %d" % [ row["접수"],row["정원"],row["정원외"]] if $debug>=2

    # 접수 현황 계산
    if row["정원"].to_i != 0 && row["접수"].to_f != 0 && row["정원외"].to_f == 0
			enrolment_ratio = row["접수"].to_f.percent_of(row["정원"].to_f)
    elsif row["정원"].to_i != 0 && row["접수"].to_i != 0 && row["정원외"].to_i > 0 
			# 정원 초과한 경우, 100 %
      enrolment_ratio = 100
    else
      enrolment_ratio = 0
    end

    # 총 강좌 수
    lect_total += 1

    # 총 강좌 대비 수강 신청 비율
    case enrolment_ratio  
    when 0 .. CRIT
      $crit += 1
    when CRIT .. WARN
      $warn += 1
    else
      $norm += 1
    end

    #  for debug
    puts "Lecture: %s / enrolment_ratio: %d/ Day: %s" % [ title, enrolment_ratio, row["학습기간"] ] if $debug >= 1

		# Save the results
    mystat = sprintf('%%   %s/%s', row["접수"], row["정원"])
    $enrolment_status.push({ dataid: "lect"+lect_total.to_s, category: row["훈련구분"], title: title, manager: row["과정담당자"],  ratio: enrolment_ratio, stat: mystat , dday: row["학습기간"], location: row["개최지역본부"]  } )
	end

    # 전체 강좌 수강 비율
    $total_enrolment = { total: lect_total, 
        crit: $crit, crit_ratio: $crit.percent_of(lect_total),
        warn: $warn, warn_ratio: $warn.percent_of(lect_total),
        norm: $norm, norm_ratio: $norm.percent_of(lect_total)
    }                 
    if $debug >= 1
        msg =  "Total: %d / Critical %d (%d %%) / Warning %d (%d %%) / Normal %d (%d %%)" % 
              [lect_total, 
                $crit, $crit.percent_of(lect_total),
                $warn, $warn.percent_of(lect_total), 
                $norm, $warn.percent_of(lect_total)
        ]
        puts msg

        puts $total_enrolment.inspect 
    end
end

# Sending status info
def show_enrolment_status

	## Sending data
    #
    # data format: $enrolment_status = { dataid: "lect"+lect_total.to_s, title: c1, manager: c3,  ratio: enrolment_ratio, stat: c6, total: c7 }
    # sending format:  send_event('lect1', { current:current_ratio, last:last_ratio, stat:current_fail, total:total })
    #
    $enrolment_status.each do |h|
			puts h.pretty_inspect if $debug>=2
			send_event h[:dataid], { current: h[:ratio], last: h[:ratio], stat: h[:stat], manager: h[:manager], category: h[:category], title: h[:title], dday: h[:dday], location: h[:location] }
    end
end

# Main
SCHEDULER.every '30s', :first_in => 0 do |job|


#def test_main

	time = Time.new
	print "=================== Start: %s ==================== \n" % time.strftime("%Y-%m-%d %H:%M:%S") if $debug
	$errdate = time.strftime("%Y%m%d-%H%M%S")

	if ( File.exist?(STATDATA) )
		print "1.Reading from %s\n" % STATDATA
		sort_csv_data
		print "2.Calc enrolment ratio\n"
		read_lecture_stat
		print "3.Sending data\n"
		show_enrolment_status
	else
		print "Failed to read %s\n" % STATDATA
	end

	puts "======================== End of Loop ===========================\n" if $debug

end



result = client.query("SELECT * FROM new_table ORDER BY id DESC LIMIT 1")
last_row = result.first

# Print each column of the last row
last_row.each do |key, value|
  puts "#{key}: #{value}"
end














#test_main()
