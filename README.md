# veracode-API
API to access Veracode REST API and veracode-ui issues

The current version of the API is bash based, but the idea is to rewrite parts of it in Node or Python.

### Example of scan file

* For Java/Maven based app

```bash
#!/usr/bin/env bash

. ./scan/api-veracode-xyz.sh

PROJECT=xxxxx
REPO_NAME=aaaa-bbbb-ccc
APP_ID=123456

function build_Files {
    build_Dependency "aaaa-common" "1.6.2"
    build_Dependency "aaaa-bbbb-security" "1.9"

    mvn install -DskipTests -Dcheckstyle.skip=true
}

function zip_Targets {
    rm $TARGET_FILE
    zip -r $TARGET_FILE ./target/aaaa-bbbb-ccc-1.0.0-SNAPSHOT.jar
}

setup
clone
build_Files
zip_Targets
trigger_Scan
```

* for NodeJS project

```bash

#!/usr/bin/env bash

. ./scan/api-veracode-xyz.sh

PROJECT=xxx
REPO_NAME=aaaaa
APP_ID=12345


function zip_Targets {
    rm $TARGET_FILE
    zip -r $TARGET_FILE server.js
    zip -r $TARGET_FILE app server shared
}

setup
clone
zip_Targets
trigger_Scan
```


### using veracode api as REPL

* install it on cmd line: ```cd ./api/bash/;. api.sh; cd ../..```
* set veracode credentials: ```export API_USERNAME=xxx.xx@xxxx.xx.xxx``` and ```export API_PASSWORD=xxxx```
* list of current veracode apps: ```veracode_app_list```

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


### Resources

* API Automation script - https://github.com/aparsons/veracode (in bash)
* Other authomation scripts - https://github.com/OnLineStrategies/veracode-scripts (in phython)
* Jenkins plugin - https://github.com/mbockus/veracode-scanner

