#!/bin/bash
#
# SCRIPT: task_5_combined_log_reader.sh
# PURPOSE: Reads configuration file and runs tests based on configuration.
# AUTHOR: Dmitry Huba
# DATE: 2025-10-16
# ORGANIZATION: TTHK
#
# Check if sites.conf exists
if [ ! -f "sites.conf" ]; then
    echo "ERROR: sites.conf file is missing!"
    exit 1
fi

echo "INFO: sites.conf found. Reading configuration..."

# Read configuration from sites.conf
while IFS='|' read -r URL USER PASS EXPECTED_STATUS
do
    # Check if the line is not empty
    if [ -z "$URL" ] || [ -z "$USER" ] || [ -z "$PASS" ] || [ -z "$EXPECTED_STATUS" ]; then
        echo "WARNING: Empty line or missing data in sites.conf, skipping line."
        continue
    fi

    # Debugging: Print the data being read
    echo "DEBUG: Read from sites.conf - URL: $URL, USER: $USER, PASS: $PASS, EXPECTED_STATUS: $EXPECTED_STATUS"

    for i in {1..5}
    do
        # Run the authentication test
        HTTP_STATUS=$(curl -u "$USER:$PASS" -s -o /dev/null -w "%{http_code}" "$URL")

        # Log the result
        LOG_FILE="combined_log_$(date +%Y%m%d_%H%M%S).log"
        echo "Test $i - URL: $URL, Expected Status: $EXPECTED_STATUS, Received Status: $HTTP_STATUS" >> "$LOG_FILE"

        if [ "$HTTP_STATUS" -eq "$EXPECTED_STATUS" ]; then
            echo "TEST OK - Authentication successful." >> "$LOG_FILE"
        else
            echo "TEST ERROR - Authentication failed." >> "$LOG_FILE"
        fi
    done
done < sites.conf

