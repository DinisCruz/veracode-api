# veracode-ui
API to access Veracode REST API and veracode-ui issues

## using veracode api

    - install it on cmd line - ```cd ./api/bash/;. api.sh; cd ../..```
    - set veracode credentials -```export API_USERNAME=xxx.xx@bbc.co.uk``` and ```export API_PASSWORD=xxxx```
    - list of current veracode apps - veracode_app_list

curent list of commands

```
veracode_api_invoke                 veracode_app_build_begin_prescan    
veracode_app_build_info             veracode_app_info                   
veracode_create_app                 veracode_api_invoke_F               
veracode_app_build_begin_scan       veracode_app_build_prescan_results  
veracode_app_list                   veracode_app_build                  
veracode_app_build_in_sandbox       veracode_app_build_upload_file      
veracode_app_sandboxes             
```


**Resources**

* API Automation script - https://github.com/aparsons/veracode (in bash)
* Other authomation scripts - https://github.com/OnLineStrategies/veracode-scripts (in phython)
* Jenkins plugin - https://github.com/mbockus/veracode-scanner

