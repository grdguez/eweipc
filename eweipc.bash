#!/bin/bash

# Setting envrionment variables
PATH=

# Variables
	
	# Note >> as we want ti keep previous log
	# info of this program, if any exists.
	# This is also the first time writing to
	# ./program.log so it's created by this command.
	printf "%s: Setting variables.\n" "$(date)" >> ./program.log

	# mcpn: main config path name.
	mcpn="./eweipc.config"
	# cip: current ip.
	cip="$(./getip.bash)"
	# oip: old ip.
	# Note $s as we are getting from last line.
	oip="$(sed -n -E '$s:(.*)@.*:\1:Ip' < ./ip.log)"
	# plpn: program log path name.
	plpn="./program.log"
	#efpn: email file path name.
	efpn="./email.txt"
	# fh: From header.
	fh="From: <"$(sed -n -E 's:^SendFrom=(.*):\1:Ip' < ${mcpn})">"
	# th: To header.
	th="To: <"$(sed -n -E 's:^SendTo=(.*):\1:Ip' < ${mcpn})">"
	# dh: Date header.
	dh="Date: "$(date --rfc-email)""
	# ccpn: curl config path name.
	ccpn="./curl.config"

	printf "%s: Finished setting variables.\n" "$(date)" >> "${plpn}"

# IP comparison
	printf "%s: Performing ip comparison.\n" "$(date)" >> "${plpn}"

	if [[ $cip != $oip ]]; then
		printf "%s: IP has changed.\n" "$(date)" >> "${plpn}"
		
		# Generate email.
		printf "%s: Generating email.\n" "$(date)" >> "${plpn}"
		# Note single > as we want to always
		# create a new email every time this
		# part is run.
		printf "${dh}\r\n" > "${efpn}"
		# Note >> as we are just appending now.
		printf "${fh}\r\n" >> "${efpn}"
		printf "${th}\r\n" >> "${efpn}"
		# Note CRLFCRLF as we are ending header
		# section.
		printf "Subject: IP changed.\r\n\r\n" >> "${efpn}"
		printf "Your new IP is ${cip}.\n"  >> "${efpn}"
		printf "%s: Email generated.\n" "$(date)" >> "${plpn}"
		
		# Send email.
		printf "%s: Sending email.\n" "$(date)" >> "$plpn"
		curl --config ${ccpn} 2>> "${plpn}"
		# Note double \n as we want to 
		# make clear separation for next log entry.

		# Update ip.log.
		printf "%s: Updating ip log.\n" "$(date)" >> "${plpn}"
		printf "%s@%s\n" "${cip}" "$(date)" >> ./ip.log
		printf "%s: End of program execution.\n" "$(date)" >> "${plpn}"

	else
		# Note double \n as this finishes this
		# log report.
		printf "%s: IP hasn't changed.\n\n" "$(date)" >> "${plpn}"
	fi
