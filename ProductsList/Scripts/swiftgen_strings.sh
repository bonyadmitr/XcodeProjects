## add to xcode run script
# /bin/sh ./Scripts/swiftgen.sh

## without pod
if which swiftgen >/dev/null; then
    swiftgen strings "$PROJECT_DIR/ProductsList/App/en.lproj/Localizable.strings" --output "$PROJECT_DIR/ProductsList/App/L10n.swift" -p "$PROJECT_DIR/Scripts/SwiftGenTemplates/strings_structured-swift4.stencil"
    # -templateName structured-swift4 
else
    echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
fi

## pod version
#$PODS_ROOT/SwiftGen/bin/swiftgen strings "$PROJECT_DIR/ScriptsTest/Resources/en.lproj/Localizable.strings" --output "$PROJECT_DIR/ScriptsTest/Resources/L10n.swift" -t structured-swift3
