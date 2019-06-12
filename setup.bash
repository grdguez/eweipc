#!/bin/bash

# Variables:
	# ccpn : curl config path name
	ccpn="./curl.config"
	# mcpn : main config path name
	mcpn="./eweipc.config"
	# mspn: main script path name
	mspn="./eweipc.bash"
	# mf : mail from
	mf=$(sed -n -E 's:^SendFrom=(.*):\1:Ip' < $mcpn)
	# mr: mail rcpt
	mr=$(sed -n -E 's:^SendTo=(.*):\1:Ip' < $mcpn)
	# nfpn: netrc file path name
	nfpn=$(sed -n -E 's:^netrcFileLocation=(.*):\1:Ip' < $mcpn)
	# ufpn: upload file path name
	ufpn="./email.txt"
	# cef: current environment file
	cef="./current_env.txt"


# Generate curl.config:
	echo "Generating curl.config file." >&2
	# Note only one >. This is because we want a new
	# curl.config every time setup.bash is run.
	printf "netrc-file = \"${nfpn}\"\n" > "$ccpn"
	# Now we are just appending so >>.
	printf "ssl-req \n" >> "$ccpn"
	printf "url = \"smtp://smtp.gmail.com:587\"\n" >> "$ccpn"
	printf "mail-from = \"${mf}\"\n" >> "$ccpn"
	printf "mail-rcpt =  \"${mr}\"\n" >> "$ccpn"
	printf "upload-file = \"${ufpn}\"" >> "$ccpn"
	echo "Generation of curl.config complete." >&2

# Generate ip.log
	echo "Generating ip.log file." >&2
	# Note >>. This is because we
   	# want to append if a log already exists.
	# Allows us to run setup multiple times
	# without losing the old log.	
	printf "%s@%s\n" "$(./getip.bash)" "$(date)" >> ip.log	
	echo "Generation of ip.log complete." >&2

# Generate current environment file.
	echo "Creating file with current environment." >&2
	# Note one > as we always want unique entries to cef.
	env > "${cef}"
	echo "Current environment file created." >&2

# Set PATH variable in ./eweipc.bash.
	echo "Setting PATH variable in ./eweipc.bash." >&2
	# Get PATH variable from cef.
	pv="$(sed -n -E 's:^PATH=(.*):\1:p' < "${cef}")"
	# Set PATH variable in ./eweipc.bash.
	sed -E -i "s,^(PATH=).*,\1"${pv}"," "${mspn}"
	echo "PATH variable written to "${mspn}"." >&2
