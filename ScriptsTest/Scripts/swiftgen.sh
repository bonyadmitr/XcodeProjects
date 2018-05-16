## add to xcode run script
# /bin/sh ./Scripts/swiftgen.sh

if which swiftgen >/dev/null; then
    swiftgen strings "$PROJECT_DIR/WeatherApp/App/Resources/en.lproj/Localizable.strings" --output "$PROJECT_DIR/WeatherApp/App/Resources/Strings.swift" -t structured-swift3
else
    echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
fi
