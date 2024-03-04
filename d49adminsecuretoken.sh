#!/bin/bash

#Prompts the user for administrator password
while :; do

    #NOTE bash native 'read' will probably do what you were accomplishing with
    #     osascript and will be more portable across varios OS flavors (works with
    #     any 'bash' implementation consistently, including linux).
    # -p <prompt> => use the provided 'prompt' as the prompt
    # -s => do not echo input on stdout (won't show the user's password back to them
    IFS= read -rs -p "Please input your Macbook Password:" adminPassword
    echo "" #the -p option of read will not insert a newline/carriage-return

    #NOTE it may not be the same on MacOS, but in some linux distros the authentication
    #     will be cached and the user will not need to be prompted again for a password.
    #     'sudo -k' destroys any prior cached auth data.
    sudo -k

    result=$(
        echo "$adminPassword" | sudo -S ls /var/root &>derp
        echo "$?"
    )

    # check result, exit loop if correct password was supplied.
    # continue loop and prompt again if otherwise.
    if [[ "$result" = "0" ]]; then
        break
    else
        # prints to stderr (with redirection)
        echo 'Incorrect Password' >&2
    fi

    #NOTE not strictly necessary, but a 'tight loop' is *considerably* more vulnerable to
    #     brute-force attacks. The larger security concern is in testing the plaintext
    #     password without salt+hash.
    sleep 1

done

#Pulls current LAPS password and grants to d49admin
currentUser=$(id -un)
LAPSPassword=$(macOSLAPS -getPassword | cat /var/root/Library/Application\ Support/macOSLAPS-password)
sysadminctl -secureTokenOn -user d49admin -password $LAPSPassword -adminUser $currentUser -adminPassword $adminPassword
