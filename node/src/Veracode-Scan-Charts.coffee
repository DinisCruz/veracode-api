Veracode_Scan_Report = require './Veracode-Scan-Report'
Chart_Engine         = require './Chart-Engine'

class Veracode_Scan_Charts
  constructor: ->
    @.scan_Report  = new Veracode_Scan_Report()
    @.chart_Engine = new Chart_Engine()


  create_Chart_Flaw_Categories: (callback)=>
    data          =  @.scan_Report.path_Flaws_Stats.load_Json()
    target_Folder = @.scan_Report.reports_Folder.path_Combine '_graphs'

    using @.chart_Engine, ->
      bar_Chart = using @.bar_Chart(), ->

        for name,value of data.flaw_Categories
          @.add_Bar name, value
        @.title("Veracode Scan Flaw Categories")
        return @
      target_File = target_Folder.path_Combine 'flaw_Categories.png'
      chart_Data  = bar_Chart.data
      @.create_Chart chart_Data, target_File, callback

module.exports = Veracode_Scan_Charts