eweipc: Email When External IP changes.

Summary of Contents:
Design
Setup
Troubleshooting

Design:

This section can be skipped by users.
Users need only read the Setup and
Troubleshooting sections.

eweipc is designed to be run using a cron
job. The program is designed to be run in
a single directory operating as a kind of
stand-alone system. This is done so that
the system can be moved around and placed
anywhere the user finds convenient.

The programs in the system are:

eweipc.bash
setup.bash
getip.bash

The files that aren't programs:

readme.txt
eweipc.config
ip.log
program.log
curl.config
current_env.txt
email.txt

Note: some files will not be present before
setup, as they are generated programmatically.

Setup:

This is a bash program AND requires curl and
dnsutils installed on your system.

You will need a gmail app password.

You will need a netrc file. The content of
the netrc file should be as follows:

machine smtp.gmail.com
login <gmail_address>
password <app_password>

Note: the gmail address in the netrc file
MUST be the one you have created the app
password for AND the gmail address which
is sending the email.


Fill in the details in eweipc.config as instructed
in the file.

Run setup.bash

Setup crontab for your user as follows:
$ crontab -e

Then add the following line to your crontab file:
*/5 * * * * { cd <absolute_path>/eweipc; ./eweipc.bash; }

Save and exit.

This is set up to run the program every 5 minutes.
cd is included in the command list in order to give
the cron environment the right PWD environment variable.

Troubleshooting:

Read /var/log/syslog if program.log is not
helping; search for strings like "cron",
"gmail", and "SMTP".

Ensure files have appropriate permissions.
