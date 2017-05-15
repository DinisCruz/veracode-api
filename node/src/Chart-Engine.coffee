Buffer::save_As = (file_Path)->
  fs        = require('fs')
  out       = fs.createWriteStream(file_Path);
  out.write(@);
  file_Path

jsdom       = require('jsdom')

class Chart_Engine

  constructor: ->
    @.document = null
    @.window   = null

  create_Chart: =>
    new @.chart @.ctx, @.test_Data()      # will store chart in @.canvas

  save_Chart: (callback)=>
    save = (blob) =>
      jsdom.blobToBuffer blob
           .save_As __dirname.path_Combine 'chart.png'
      callback()

    @.canvas.toBlob save                  #, "image/png"


  setup_Jsdom: (callback)=>
    html    = '<canvas id="myChart" width="500" height="500"></canvas>>'
    scripts = [ 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.2.2/Chart.js' ]      # don't like this, online dependency

    jsdom.env html, scripts, (err, window) =>
      @.window        = window
      @.document      = window.document
      #@.chart         = require 'chart.js'         # using local copy of chart.js is not working so for now load it from the CDN
      global.window   = @.window                    # need to set these values since jsdom makes calls to window.* internally
      global.document = @.document
      @.chart         = @.window  .Chart
      @.canvas        = @.document.getElementById('myChart')
      @.ctx           = @.canvas  .getContext('2d')

      callback()



  test_Data: ()=>
    type: 'line'
    data:
      labels: [
        'Red'
        'Blue'
        'Yellow'
        'Green'
        'Purple'
        'Orange', 'aaa','bbb'
      ]
      datasets: [ {
          label           : "My First dataset",
          backgroundColor : "rgba(179,181,198,0.2)",
          borderColor     : "rgba(179,181,198,1)",
          pointBackgroundColor: "rgba(179,181,198,1)",
          pointBorderColor: "#fff",
          pointHoverBackgroundColor: "#fff",
          pointHoverBorderColor: "rgba(179,181,198,1)",
          data: [15, 29, 10, 11, 26, 15, 40,11]
        }, {
          label           : 'Red and Green'
          data            : [10,22,13,4,25,22,33,11]
          backgroundColor : "rgba(255,0,0,0.5)"
          borderColor     : 'green'
          fill            : true
          steppedLine     : true
          borderWidth     : 2

        }, {
          label: '# of Votes'
          data: [ 12, 13, 3, 5, 1, 12 ,22, 33]
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)'
            'rgba(54, 162, 235, 0.2)'
            'rgba(255, 206, 86, 0.2)'
            'rgba(75, 192, 192, 0.2)'
            'rgba(153, 102, 255, 0.2)'
            'rgba(255, 159, 64, 0.2)'
          ]
          borderColor: [
            'rgba(255,99,132,1)'
            'rgba(54, 162, 235, 1)'
            'rgba(255, 206, 86, 1)'
            'rgba(75, 192, 192, 1)'
            'rgba(153, 102, 255, 1)'
            'rgba(255, 159, 64, 1)'
          ]
          borderWidth: 1
        } ]
    options:
      responsive: false
      animation: false
      width: 400
      height: 400
      scales: yAxes: [ { display: true , ticks: beginAtZero: true,  _max: 10, min: 0, stepSize: 6} ]
#class Chart_Engine
#  constructor: ->
#
#  test_Data: ()->
#    type: 'bar',
#    data: {
#      labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
#      datasets: [{
#        label: '# of Votes',
#        data: [12, 19, 3, 5, 2, 3],
#        backgroundColor: [
#          'rgba(255, 99, 132, 0.2)',
#          'rgba(54, 162, 235, 0.2)',
#          'rgba(255, 206, 86, 0.2)',
#          'rgba(75, 192, 192, 0.2)',
#          'rgba(153, 102, 255, 0.2)',
#          'rgba(255, 159, 64, 0.2)'
#        ],
#        borderColor: [
#          'rgba(255,99,132,1)',
#          'rgba(54, 162, 235, 1)',
#          'rgba(255, 206, 86, 1)',
#          'rgba(75, 192, 192, 1)',
#          'rgba(153, 102, 255, 1)',
#          'rgba(255, 159, 64, 1)'
#        ],
#        borderWidth: 1
#      }]
#    },
#    options: {
#      responsive: false,
#      width: 400,
#      height: 400,
#      animation: false,
#      scales: {
#        yAxes: [{
#          ticks: {
#            beginAtZero:true
#          }
#        }]
#      },
#      tooltips: {
#        mode: 'label'
#      }
#    }
#  new_Chart: (width=600, height=600)=>
#    @.test_Data()
#    chartNode = new ChartjsNode(width, height)
#    return chartNode.drawChart(@.test_Data()).then () =>
#      console.log 'here'
#      return chartNode

module.exports = Chart_Engine