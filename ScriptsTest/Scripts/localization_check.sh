OUTPUT=$(./Scripts/localization_check)

if [[ $OUTPUT = "" ]]; then
echo "localization_check cleared"
else
echo "warning: localization_check"
echo $OUTPUT
fi
