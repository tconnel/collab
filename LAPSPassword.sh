#!/bin/bash

#Prompts user for administrator password
status=$(sysadminctl -secureTokenStatus 'd49admin' 2>&1 | awk '{print $7}')
i=0
while [[ $status == 'DISABLED' ]]; do

adminPassword=$(
    osascript<<END
repeat
	considering case
		set init_pass to text returned of (display dialog "Please enter your MacBook Password:" with icon POSIX file "/var/tmp/d49Logo.png" default answer "" with hidden answer)
		set final_pass to text returned of (display dialog "Please verify your password below." with icon POSIX file "/var/tmp/d49Logo.png" buttons {"OK"} default button 1 default answer "" with hidden answer)
		if (final_pass = init_pass) then
			exit repeat
		else
			set display_text to "Mismatching passwords, please try again"
		end if
	end considering
end repeat
    return final_pass
    END
)
i=$((($i+1)))
#Pulls current LAPS password and grants to d49admin
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ {print $3}')

/usr/local/laps/macoslaps -getPassword && LAPSPassword=$(cat /var/root/Library/Application\ Support/macOSLAPS-password)

echo "$LAPSPassword"
sysadminctl -secureTokenOn d49admin -password $LAPSPassword -adminUser "$currentUser" -adminPassword "$adminPassword"
sleep 5
status=$(sysadminctl -secureTokenStatus 'd49admin' 2>&1 | awk '{print $7}')
    if [[ $status == 'ENABLED' ]]; then
        break
    elif [[ $i -ge 3 ]]; then
		break
    fi
done

if [[ $i -lt 3 ]]; then
    exit 0
else
    echo "Attempts: $i"
	echo "Too many bad password attempts"
    exit 1
fi
