#!/bin/bash
#
# SCRIPT: task_4_index_listing_test.sh
# PURPOSE: Checks if directory listing is disabled on the server.
# AUTHOR: Dmitry Huba
# DATE: 2025-10-16
# ORGANIZATION: TTHK
#
# Perform the request to the test directory
INDEX_LISTING=$(curl -s http://localhost/config/)

# Log the result
LOG_FILE="index_listing_test_$(date +%Y%m%d_%H%M%S).log"
echo "$INDEX_LISTING" >> "$LOG_FILE"

# Check if the response contains directory listing keywords
if echo "$INDEX_LISTING" | grep -q "Index of"; then
    echo "TEST ERROR - Directory listing is allowed."
    echo "TEST ERROR - Directory listing is allowed." >> "$LOG_FILE"
else
    echo "TEST OK - Directory listing is disabled."
    echo "TEST OK - Directory listing is disabled." >> "$LOG_FILE"
fi

