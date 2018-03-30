fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

# Available Actions
## iOS
### ios carthages
```
fastlane ios carthages
```
Update Carthage dependencies
### ios pods
```
fastlane ios pods
```
Install Cocoapods dependencies
### ios synx
```
fastlane ios synx
```
Synchronize folders and groups in project for development
### ios clocc
```
fastlane ios clocc
```
Print code lines count
### ios create
```
fastlane ios create
```
Creates new iOS apps on both the Apple Developer Portal and iTunes Connect
### ios server
```
fastlane ios server
```
Creates new .pem, .cer, and .p12 files to be uploaded to your push server
### ios profiles
```
fastlane ios profiles
```
Creates all required certificates & provisioning profiles and stores them in a separate git repository
### ios services
```
fastlane ios services
```

### ios register
```
fastlane ios register
```

### ios appicons
```
fastlane ios appicons
```

### ios release
```
fastlane ios release
```
Deploy a new version to the App Store
### ios beta
```
fastlane ios beta
```

### ios fabric
```
fastlane ios fabric
```

### ios screenshots
```
fastlane ios screenshots
```

### ios my_snapshot
```
fastlane ios my_snapshot
```

### ios my_frameit
```
fastlane ios my_frameit
```

### ios my_gym
```
fastlane ios my_gym
```
Create ipa
### ios addTfTesters
```
fastlane ios addTfTesters
```

### ios my_pilot
```
fastlane ios my_pilot
```

### ios my_crashlytics
```
fastlane ios my_crashlytics
```

### ios ubertesters
```
fastlane ios ubertesters
```

### ios diawi
```
fastlane ios diawi
```

### ios my_applivery
```
fastlane ios my_applivery
```

### ios my_match
```
fastlane ios my_match
```

### ios my_deliver
```
fastlane ios my_deliver
```
Upload to App Store and submit for review
### ios my_precheck
```
fastlane ios my_precheck
```
check metadata
### ios my_scan
```
fastlane ios my_scan
```
run tests
### ios set_versions
```
fastlane ios set_versions
```
set versions from git tag
### ios test2
```
fastlane ios test2
```

### ios fabric2
```
fastlane ios fabric2
```

### ios tf2
```
fastlane ios tf2
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
