OUTPUT=$(./Scripts/AbandonedStrings "$PROJECT_DIR/ScriptsTest/")

## not working
#OUTPUT2=$"Searching for abandoned resource strings… No abandoned resource strings were detected."
#if [ $OUTPUT == $OUTPUT2 ]; then
#echo $OUTPUT2

## if OUTPUT containts "...No abandoned..."
if [[ $OUTPUT = *"No abandoned resource strings were detected." ]]; then
    echo "AbandonedStrings cleared"
else
    echo "warning: AbandonedStrings"
    echo $OUTPUT
fi
