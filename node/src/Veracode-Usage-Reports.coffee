Usage_Report = require './models/Usage-Report.model'

require 'fluentnode'

Number::to_Decimal = -> Number.parseFloat(@.toFixed(4))

fix_Numbers = (target)->                    # to address this issue https://github.com/DinisCruz/Book_Software_Quality/issues/90
  for key,value of target when is_Number(value)
    target[key] = value.to_Decimal()

class Veracode_Usage_Reports
  constructor: ->
    @.base_Folder    = wallaby?.localProjectDir || '.'.real_Path()
    @.reports_Folder = @.base_Folder      .path_Combine '../../reports'
    @.scan_History   = @.reports_Folder   .path_Combine '_scan_history'
    @.parsed_History = @.scan_History     .path_Combine '_parsed'

    if @.reports_Folder.folder_Exists()       # if there is a reports folder, then create the other folders (in case they don't exist)
      @.scan_History   .folder_Create()
      @.parsed_History .folder_Create()

  latest_Usage_Report_Csv: =>
    @.scan_History.path_Combine("#{@.latest_Usage_Report_Id()}.csv").file_Contents()

  latest_Usage_Report_Json: =>
    data = @.parsed_History.path_Combine('usage-reports-raw.json').load_Json()
    return data.filter (item)->             # remove this App (since it was testing and was adding lots of non relevant findings)
      return item.App.not_Contains 'Infosec Trial'

  latest_Usage_Report_Id: =>
    @.scan_History.path_Combine('_latest_report').file_Contents().trim()

  save_Latest_Usage_Report_As_Json: (callback)=>
    Usage_Report.Parse_Entries @.latest_Usage_Report_Csv(), (data)=>
      target_File = @.parsed_History.path_Combine 'usage-reports-raw.json'
      data.json_Pretty().save_As target_File
      callback target_File

  transform_Usage_Report: =>
    raw_Data = @.latest_Usage_Report_Json()
    report = {}
    fields = ['App', 'App ID', 'Version', 'Version ID', 'Is Latest Pub Build']
    for entry in raw_Data

      if entry['App'] is 'myrecs-audit'
      #if entry['Is Latest Pub Build'] is '0'

        item = {}
        for name in fields
          item[name] = entry[name]

        report[item.App] = item

        #console.log item
    return report


  create_Report_Stats: =>
    target_File = @.parsed_History.path_Combine 'stats.json'

    stats =
      number_of_Scans : 0       #
      uploaded_Kb     : 0       # KB Uploaded
      analysis_Kb     : 0       # Analysis Size KB
      lines_of_code   : 0       # Lines Of Code
      flaws_total     : 0       # Flaws
      flaws_very_high : 0       # Very High Flaws
      flaws_high      : 0       # High Flaws
      flaws_medium    : 0       # Medium Flaws
      flaws_low       : 0       # Low Flaws
      flaws_very_low  : 0       # Very Low Flaws

    for entry in @.latest_Usage_Report_Json()
      using stats, ->
        @.number_of_Scans++
        @.uploaded_Kb     += Number(entry['KB Uploaded'     ])
        @.analysis_Kb     += Number(entry['Analysis Size KB'])
        @.lines_of_code   += Number(entry['Lines Of Code'   ])
        @.flaws_total     += Number(entry['Flaws'           ])
        @.flaws_very_high += Number(entry['Very High Flaws' ])
        @.flaws_high      += Number(entry['High Flaws'      ])
        @.flaws_medium    += Number(entry['Medium Flaws'    ])
        @.flaws_low       += Number(entry['Low Flaws'       ])
        @.flaws_very_low  += Number(entry['Very Low Flaws'  ])

    fix_Numbers(stats)

    stats.json_Pretty().save_As target_File
    return target_File

  create_Report_Targets: =>
    target_File = @.parsed_History.path_Combine 'targets.json'
    targets = {}
    for entry in @.latest_Usage_Report_Json()
      targets[entry.App] ?= { number_of_scans: 0, scans: []}
      using targets[entry.App], ->
        @.number_of_scans++
        data = {}
        using data, ->
          @.uploaded_Kb     = entry['KB Uploaded'     ]
          @.analysis_Kb     = entry['Analysis Size KB']
          @.lines_of_code   = entry['Lines Of Code'   ]
          @.flaws_total     = entry['Flaws'           ]
          @.flaws_very_high = entry['Very High Flaws' ]
          @.flaws_high      = entry['High Flaws'      ]
          @.flaws_medium    = entry['Medium Flaws'    ]
          @.flaws_low       = entry['Low Flaws'       ]
          @.flaws_very_low  = entry['Very Low Flaws'  ]
          @.score           = entry['Score'           ]
          @.language        = entry['Language'        ]
        @.scans.add data

      #console.log targets[entry.App]
    targets.json_Pretty().save_As target_File
    return target_File

module.exports = Veracode_Usage_Reports