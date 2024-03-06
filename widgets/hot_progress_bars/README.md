# Hot Progress Bar Widget

## Description

This widget is a fork of the original [Progress Bar Widget](https://gist.github.com/mdirienzo/6716905), a widget made for [Dashing](http://shopify.github.io/dashing/).

The original widget shows multiple animated progress bars and reacts dynamically to new information being passed in. 
This forked widget adds the possibility to define warning and critical thresholds for each progress bars, which will change their color depending on the threshold reached. 

Anything with a current state and with a projected max/goal state can easily be represented with this widget.
Some sample ideas would be to show progress, completion, capacity, load, fundraising, and much more.

With the threashold feature, it is typically aimed at being used in simple green/orange/red monitoring dashboards.

## Features

* Animating progress bars - Both the number and bar will grow or shrink based on new data that is being passed to it.
* Responsive Design - Allows the widget to be resized to any height or width and still fit appropriately. The progress bars will split up all available space amongst each other, squeezing in when additional progress bars fill the widget.
* Easy Customization - Change the base color in one line in the scss and have the entire widget color scheme react. The font size and progress bar size are handled by a single magic variable in the scss that will scale each bar up proportionally.
* As a bonus, this widget can also play a sound when status is modified. Just add one or more `data-*status*sound` attributes with the value set to an absolute or relative url pointing to an audio file.  *status* must be one of ok, critical, warning or unknown.

## Usage

With this sample widget code in your dashboard:  
```html
<li data-row="1" data-col="1" data-sizex="2" data-sizey="1">
  <div data-id="progress_bars" data-view="HotProgressBars" data-title="Project Bars" data-zebra="1" data-criticalsound="/mp3/critical.mp3"></div>
</li>
```
You can disable the zebra stripping feature by removing or setting `data-zebra` attribute to 0.

You can send an event through a job like the following:
`send_event( 'progress_bars', {title: "", progress_items: []} )`

`progress_items` is an array of hashes that follow this design: `{name: <value>, progress: <value>, critical: <value>, warning: <value>, localScope: <value>}`
* The `name` key can be any unique string that describes the bar.
* The `progress` variable is a value from 0-100 that will represent the percentage of the bar that should be filled. Valid inputs include: `24, "24", "24%", 24.04`

`critical`, `warning` and `localScope` are optional values with the following meaning:
* `critical` defines the critical threshold, the progress bar will turn red if the value reaches this threashold,
* `warning` defines the warning threshold, the progress bar will turn yellow if the value reaches this threshold,
* `localScope` can be 0 or 1 and configures whether or not the whole widget should change its color if a threshold is reached for this progress bar.

Sending a request to a web service for a JSON response or reading from a file can produce this information easily.
