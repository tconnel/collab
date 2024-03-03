#!/bin/bash

#Prompts the user for administrator password
#NOTE bash native 'read' will probably do what you were accomplishing with
#     osascript and will be more portable across varios OS flavors (works with
#     any 'bash' implementation consistently).
read -s -p "Please input your Macbook Password:" adminPassword

result=$(
    echo "$adminPassword" | sudo -S ls /var/root 2>&1 >/dev/null
    echo "$?"
)

if [[ "$result" != "Password:0" ]]; then
    osascript -e 'display dialog "Password Incorrect"'
fi

#Pulls current LAPS password and grants to d49admin
currentUser=$(id -un)
LAPSPassword=$(macOSLAPS -getPassword | cat /var/root/Library/Application\ Support/macOSLAPS-password)
sysadminctl -secureTokenOn -user d49admin -password $LAPSPassword -adminUser $currentUser -adminPassword $adminPassword
