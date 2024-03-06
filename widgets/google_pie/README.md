## Description ##

A [Dashing](http://shopify.github.com/dashing) widget to show a [Google Visualizations Pie Chart](https://developers.google.com/chart/interactive/docs/gallery/piechart)
on a dashboard.

## Installation ##

Copy the `google_pie.coffee`, `google_pie.html` and `google_pie.scss` file to into `/widgets/google_pie` directory.

Add the following to the dashboard layout file:

```html
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", {packages:["corechart"]});
    </script>
```

Then to include the widget on the dashboard, add the following item to your dashboard file:

```html
    <li data-row="1" data-col="1" data-sizex="2" data-sizey="1">
      <div data-id="mychart" data-view="GooglePie"  data-title="My Chart"></div>
    </li>
```

## Options ##

The following options can be added to the `<div>` of the chart object (defaults in parenthesis):

* `data-title` - (no title) Title of the chart.
* `data-is_3d` - (false) Set to `true` to draw the pie chart in 3D.
* `data-pie_hole` - (none) Set between 0 and 1 to change the ratio of the pie that is a hole vs chart.
* `data-pie_start_angle` - (0) Set the rotation angle of the first slice of the pie.
* `data-colors` - (Google default colors) A comma separated list of colors to use for the slices.
* `data-legend_position` - (right) Position of the legend. One of 'bottom', 'left', 'labeled', 'none', 'right' or 'top'.


## Complex Example ##

The following would create a 3D chart with no legend and picking specific colors for the slices:

```html
    <li data-row="1" data-col="1" data-sizex="2" data-sizey="1">
      <div data-id="mychart" data-view="GooglePie" data-is_3d="true" data-legend_position="none" data-colors="purple, black, blue, red" data-title="My Chart"></div>
    </li>
```

## Populating the Chart ##

To send data to the chart, use send_event to send an item called `slices` with a two dimensional array. 
Make sure the first "row" in the array is an array of headers for the data.

For example:

```ruby
send_event('mychart', slices: [
        ['Task', 'Hours per Day'],
        ['Work',     11],
        ['Eat',      2],
        ['Commute',  2],
        ['Watch TV', 2],
        ['Sleep',    7]
      ])
```