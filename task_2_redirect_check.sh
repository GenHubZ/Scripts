#!/bin/bash
#
# SCRIPT: task_2_redirect_check.sh
# PURPOSE: Verifies that HTTP requests are automatically redirected to HTTPS.
# AUTHOR: Dmitry Huba
# DATE: 2025-10-16
# ORGANIZATION: TTHK
#
# Perform the request and check for a redirect to HTTPS
REDIRECT=$(curl -v http://localhost/ 2>&1 | grep Location)

# Log the result
LOG_FILE="redirect_test_$(date +%Y%m%d_%H%M%S).log"
echo "$REDIRECT" >> "$LOG_FILE"

# Check if the redirect to HTTPS was found
if [[ "$REDIRECT" =~ "Location: https://" ]]; then
    echo "TEST OK - Redirect to HTTPS successful."
    echo "TEST OK - Redirect to HTTPS successful." >> "$LOG_FILE"
else
    echo "TEST ERROR - No redirect to HTTPS found."
    echo "TEST ERROR - No redirect to HTTPS found." >> "$LOG_FILE"
fi

