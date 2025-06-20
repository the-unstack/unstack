#!/bin/sh

# Define paths for your stat files
PREV="/healthcheck/prev_stats.txt"
CURR="/healthcheck/curr_stats.txt"

# Fetch lines and store current state
wget -qO- http://localhost:4195/stats | grep -e output_sent{ -e output_error{ > "$CURR"

# If previous stats file does not exist, just copy and exit
if [ ! -f "$PREV" ]; then
    cp "$CURR" "$PREV"
    exit 0
fi

CURR_Out0_ERROR=$(grep 'output_error{label="",path="root.output.switch.cases.0.output"}' "$CURR" | cut -d' ' -f2)
PREV_Out0_ERROR=$(grep 'output_error{label="",path="root.output.switch.cases.0.output"}' "$PREV" | cut -d' ' -f2)
CURR_Out1_ERROR=$(grep 'output_error{label="",path="root.output.switch.cases.1.output"}' "$CURR" | cut -d' ' -f2)
PREV_Out1_ERROR=$(grep 'output_error{label="",path="root.output.switch.cases.1.output"}' "$PREV" | cut -d' ' -f2)

CURR_Out0_SENT=$(grep 'output_sent{label="",path="root.output.switch.cases.0.output"}' "$CURR" | cut -d' ' -f2)
PREV_Out0_SENT=$(grep 'output_sent{label="",path="root.output.switch.cases.0.output"}' "$PREV" | cut -d' ' -f2)
CURR_Out1_SENT=$(grep 'output_sent{label="",path="root.output.switch.cases.1.output"}' "$CURR" | cut -d' ' -f2)
PREV_Out1_SENT=$(grep 'output_sent{label="",path="root.output.switch.cases.1.output"}' "$PREV" | cut -d' ' -f2)

INC_Out0_ERROR=$((CURR_Out0_ERROR - PREV_Out0_ERROR))
INC_Out1_ERROR=$((CURR_Out1_ERROR - PREV_Out1_ERROR))
INC_Out0_SENT=$((CURR_Out0_SENT - PREV_Out0_SENT))
INC_Out1_SENT=$((CURR_Out1_SENT - PREV_Out1_SENT))

echo INC_Out0_ERROR:$INC_Out0_ERROR
echo INC_Out1_ERROR:$INC_Out1_ERROR
echo INC_Out0_SENT:$INC_Out0_SENT
echo INC_Out1_SENT:$INC_Out1_SENT

# Update previous for next run
cp "$CURR" "$PREV"

# check
if [ "$INC_Out0_ERROR" -gt "$INC_Out0_SENT" ] || [ "$INC_Out1_ERROR" -gt "$INC_Out1_SENT" ]; then
    echo "More errors than sucessfully sent messages"
    echo "STATUS: ERROR"
    exit 1
else
    echo "STATUS: OK"
    exit 0
fi
