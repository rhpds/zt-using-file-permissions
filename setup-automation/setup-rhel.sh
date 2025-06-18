#!/bin/bash

# Create needed user and group
groupadd team

tee /srv/status.sh << EOF
#! /bin/bash
echo -n "status.sh successfully executed by "
whoami
EOF

chmod 0750 /srv/status.sh

tee /srv/tasks.txt << EOF
1. Finish this Permissions Lab
2. Do the Networking Configuration Basics Lab
3. Listen to the latest episode of RHEL Presents
EOF

chmod 0750 /srv/tasks.txt

export CONTRACTDIR=/srv/proprietary

mkdir $CONTRACTDIR
chown $CONTRACTDIR root:root
chmod 0640 $CONTRACTDIR
touch $CONTRACTDIR/contract{01..04}.txt

echo "You should enjoy the subtle detours." > $CONTRACTDIR/contract01.txt
echo "to the fullest," > $CONTRACTDIR/contract02.txt
echo "because that is where you find the things" > $CONTRACTDIR/contract03.txt
echo "that are more important than what you want." > $CONTRACTDIR/contract04.txt
chmod 777 $CONTRACTDIR/*.txt


#set up tmux so it has to restart itself whenever the system reboots

#step 1: make a script
tee ~/startup-tmux.sh << EOF
TMUX='' tmux new-session -d -s 'root' > /dev/null 2>&1
TMUX='' tmux new-session -d -s 'guest' 'su - guest'> /dev/null 2>&1
tmux set -g pane-border-status top
tmux setw -g pane-border-format ' #{pane_index} #{pane_current_command}'
tmux set -g mouse on
tmux set mouse on
EOF

#step 2: make it executable
chmod +x ~/startup-tmux.sh
#step 3: use cron to execute
echo "@reboot ~/startup-tmux.sh" | crontab -

#step 4: start tmux for the lab
~/startup-tmux.sh