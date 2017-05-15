Chart_Engine = require '../src/Chart-Engine'


describe.only 'Chart-Engine', ->
  chart_Engine = null

  beforeEach ->
    chart_Engine = new Chart_Engine()


  it 'constructor', ->
    using chart_Engine, ->
      assert_Is_Null @.document
      assert_Is_Null @.window

  it 'create_Chart', (done)->
    using chart_Engine, ->
      @.setup_Jsdom =>
        @.create_Chart()
        done()

  it 'save_Chart', (done)->
    using chart_Engine, ->
      @.setup_Jsdom =>
        @.create_Chart()
        @.save_Chart ->
          done()

  it 'setup_Jsdom', (done)->
    using chart_Engine, ->
      @.setup_Jsdom =>
        @.window     ._keys().assert_Contains [ '_core', '_globalProxy', '__timers', '_top', '_parent', '_frameElement', '_document']
        @.document   ._keys().assert_Is ['location']
        @.canvas     .assert_Is {}
        @.ctx._keys().assert_Is [ 'canvas', 'createPattern', 'drawImage' ]
        done()

  it 'test_Data', ->
    using chart_Engine, ->
      #console.log @.test_Data()

xdescribe 'Chart-Engine', ->
  chart_Engine = null

  beforeEach ->
    chart_Engine = new Chart_Engine()

  it 'constructor', ->
    using chart_Engine, ->
      #@.base_Folder   .assert_Folder_Exists()

  it 'new_Chart', (done)->
    using chart_Engine, ->
      console.log @.new_Chart().then ()->
        console.log 'here'
      @.new_Chart()
       .then (chartNode)=>
        #console.log chartNode
        done()

  it 'test2', (done)->

    fs = require('fs')
    jsdom = require('jsdom')
    jsdom.defaultDocumentFeatures =
      FetchExternalResources: [ 'script' ]
      ProcessExternalResources: true

    jsdom.env '<html><body><div id="chart-div" style="font-size:12; width:200px; height:800px;"><canvas id="myChart" width="400" height="400" style="width:400px;height:400px"></canvas>></div></body></html>', [ 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.2.2/Chart.js' ], (err, window) ->
      global.window = window
      global.document = window.document
      # Comes from the Chart.js link above just like <script src="...
      global.Chart = window.Chart
      canvas = document.getElementById('myChart')
      ctx = canvas.getContext('2d')
      myChart = new Chart(ctx,
        type: 'line'
        data:
          labels: [
            'Red'
            'Blue'
            'Yellow'
            'Green'
            'Purple'
            'Orange'
          ]
          datasets: [ {
            label: '# of Votes'
            data: [
              12
              13
              3
              5
              21
              31
            ]
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
          width: 1400
          height: 400
          scales: yAxes: [ { ticks: beginAtZero: true } ])


      save = (blob) ->
        fs  = require('fs')
        out = fs.createWriteStream(__dirname + '/chart.png');
        out.write(jsdom.blobToBuffer(blob));
        console.log __dirname.path_Combine('chart.png')
        console.log 'here'
        done()

      canvas.toBlob(save, "image/png")


# ---
# generated by js2coffee 2.2.0


  it 'simple test' , (done)->
    ChartjsNode = require('chartjs-node');
    chartNode = new ChartjsNode(600, 600);

    promise = chartNode.drawChart
      type: 'bar'
      data:
        labels: [
          'Red'
          'Blue'
          'Yellow'
          'Green'
          'Purple'
          'Orange'
        ]
        datasets: [ {
          label: '# of Votes'
          data: [
            12
            19
            3
            5
            2
            3
          ]
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
      options: scales: yAxes: [ { ticks: beginAtZero: true } ]

    promise.then(() =>
      # now we have a chart
      # lets get the image stream
      return chartNode.getImageStream('image/png');
      ).then( (imageStream)=>
        # now you can do anything with the image, like upload to S3
        # lets get the image buffer
        console.log imageStream
        return chartNode.getImageBuffer('image/png');
      ).then( (imageBuffer) =>
          # now you can modify the raw PNG buffer if you'd like
          # want to write the image directly to the disk, no problem
          result = chartNode.writeImageToFile('image/png', './testimage.png');
          console.log ''.files()
          console.log result
          return result
      ).then( () =>
          console.log 'here'
          done()
          # now the chart is written at ./testimage.png
      )
    console.log 'at end'
