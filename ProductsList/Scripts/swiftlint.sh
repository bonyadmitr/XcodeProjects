## add to xcode run script
# /bin/sh ./Scripts/swiftlint.sh

# This allows disabling the run script when running on CI and running the linter twice.
# if [ ! -z "$RUNNING_ON_CI" ]
# then
#     echo "SwiftLint run script has been disabled"
#     exit 0
# fi

if which swiftlint >/dev/null; then
    #swiftlint

    # more options at https://docs.fastlane.tools/actions/swiftlint/
    # + https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/swiftlint.rb
    swiftlint --config Scripts/.swiftlint.yml
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
