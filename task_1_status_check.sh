#!/bin/bash
#
# SCRIPT: task_1_status_check.sh
# PURPOSE: Checks the availability of the local web server and its status code.
# AUTHOR: Dmitry Huba
# DATE: 2025-10-16
# ORGANIZATION: TTHK
#
# Logging the result in a unique file, including date and time
LOG_FILE="webtest_$(date +%Y%m%d_%H%M%S).log"

# Perform the request and extract the HTTP status code
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)

# Log the result
echo "HTTP Status Code: $HTTP_STATUS" >> "$LOG_FILE"

# Check the status and output a message
if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "TEST OK - Status: 200"  # Server is working correctly
    echo "TEST OK - Status: 200" >> "$LOG_FILE"
else
    echo "TEST ERROR - Status: $HTTP_STATUS"  # Server is down or error occurred
    echo "TEST ERROR - Status: $HTTP_STATUS" >> "$LOG_FILE"
fi

