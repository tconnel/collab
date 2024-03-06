#!/bin/bash

#Prompts the user for administrator password
adminPassword=$(
    while :;
        osascript <<END
            set userInput to the text returned of (display dialog "Please input your Macbook Password:" default answer "" with hidden answer)
        END
    done
)

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
