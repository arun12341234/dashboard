@echo off

REM === 압축 해제한 폴더명으로 수정 ===
SET WORKDIR=/home/dash-admin/Desktop/my-project

REM ==== 아래는 수정할 필요 없음. ====
SET CONTAINER_NAME=ksa-dashboard
SET EXTPORT=3030
SET EXTPORT4TEST=3040

REM Volumes to be mapped
SET CONFIG=%WORKDIR%\config
SET DASHBOARDS=%WORKDIR%\dashboards
SET JOBS=%WORKDIR%\jobs
SET WIDGETS=%WORKDIR%\widgets
SET PUBLIC=%WORKDIR%\public
SET DATA=%WORKDIR%\data
SET MYIMG=%WORKDIR%\data\logo

REM Main
SET IMAGE=frvi/dashing
SET PARAM="rst";

REM Create & Start a new container
echo "Create & starting a new dashing container - %CONTAINER_NAME%"
docker run --name %CONTAINER_NAME% ^
--restart unless-stopped ^
-e GEMS="fileutils sinatra_cyclist_multi rack_warden" ^
-e RUBYOPT=-EUTF-8  ^
-p %EXTPORT%:3030 ^
-p %EXTPORT4TEST%:3050 ^
-v %CONFIG%:/config ^
-v %DASHBOARDS%:/dashboards ^
-v %JOBS%:/jobs ^
-v %WIDGETS%:/widgets ^
-v %PUBLIC%:/public ^
-v %DATA%:/dashing/data ^
-v %MYIMG%:/dashing/assets/images/logo ^
-d %IMAGE%

REM Container 실행 확인
docker ps -l