require 'fluentnode'

Veracode_Scan_Charts = require '../src/Veracode-Scan-Charts'

describe 'Veracode-Usage-Charts', ->
  scan_Charts = null

  beforeEach ->
    scan_Charts = new Veracode_Scan_Charts()

  it 'constructor', ->
    using scan_Charts, ->
      assert_Is_Object @

  it 'create_Chart_Flaw_Categories', (done)->
    using scan_Charts, ->
      @.create_Chart_Flaw_Categories (chart_File)->
        chart_File.assert_File_Exists()
        done()
