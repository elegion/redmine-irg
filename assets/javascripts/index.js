(function() {

  nv.addGraph(function() {
    var chart = nv.models.lineChart();
    var d3Chart = d3.select('#irg svg');
    var dataUrl = jQuery(d3Chart[0][0]).parent().data('dataUrl');

    d3Chart.transition().duration(500);
    chart.xAxis
      .tickFormat(function(d) {
        var tickDate = new Date(d*1000);
        var now = new Date();
        var format = tickDate.getFullYear() == now.getFullYear() ? '%d.%m' : '%d.%m.%Y';
        return d3.time.format(format)(new Date(d*1000))
      });
    chart.xAxis.axisLabel('Date')
    chart.yAxis.axisLabel('Issues');
    jQuery.get(dataUrl, function(data) {
      d3Chart.datum(data).call(chart);
    });

    nv.utils.windowResize(chart.update);
    return chart;
  });

})();
