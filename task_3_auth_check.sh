#!/bin/bash
#
# SCRIPT: task_3_auth_check.sh
# PURPOSE: Tests authentication for secured resources.
# AUTHOR: Dmitry Huba
# DATE: 2025-10-16
# ORGANIZATION: TTHK
# 
#
# Function to test authentication
test_authentication() {
    URL=$1
    USER=$2
    PASS=$3
    EXPECTED_STATUS=$4

    HTTP_STATUS=$(curl -u "$USER:$PASS" -s -o /dev/null -w "%{http_code}" "$URL")

    # Log the result
    LOG_FILE="auth_test_$(date +%Y%m%d_%H%M%S).log"
    echo "Testing URL: $URL, Expected Code: $EXPECTED_STATUS, Received Code: $HTTP_STATUS" >> "$LOG_FILE"

    if [ "$HTTP_STATUS" -eq "$EXPECTED_STATUS" ]; then
        echo "TEST OK - Authentication successful." >> "$LOG_FILE"
    else
        echo "TEST ERROR - Authentication failed." >> "$LOG_FILE"
    fi
}

# Scenarios:
# Scenario A: Unauthorized access (expected code 401)
test_authentication "https://localhost/secure/" "invaliduser" "invalidpass" 401

# Scenario B: Successful access (expected code 200)
test_authentication "https://localhost/secure/" "validuser" "validpass" 200

# Scenario C: Wrong password (expected code 401)
test_authentication "https://localhost/secure/" "validuser" "wrongpass" 401

