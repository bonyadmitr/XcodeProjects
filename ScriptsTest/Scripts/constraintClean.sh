OUTPUT=$(./Scripts/constraintClean "$PROJECT_DIR/ScriptsTest/")

if [[ $OUTPUT = *"Cleanup finished"* ]]; then
    echo "constraintClean cleared"
else
    echo "warning: constraintClean"
    echo $OUTPUT
fi
