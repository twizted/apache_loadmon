#!/bin/bash

#  Apache load monitoring script
#  Copyright (C) 2016 Armando Vega
# 
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.


LOG_FILE=/tmp/loadmon.log
LOAD_THRESH=0.10
PROC_LIMIT=15

LOOP_IDLE=5
LOOP_MON=1
LOOP_CUR=$LOOP_IDLE


while true; do
	cur_load=$(uptime | awk '{print ($(NF-2))}' | tr -d [,])
	if [ $(echo "$cur_load>$LOAD_THRESH" | bc) -ne 0 ]; then
		LOOP_CUR=$LOOP_MON
		echo "System load exceeding threshold ($cur_load > $LOAD_THRESH), dumping log.."
		echo -e "\n\nThreshold exceeded on: $(date) - load: $cur_load, thresh: $LOAD_THRESH" >> $LOG_FILE
		ps -Ao pcpu,pmem,pid,user,args --no-headers --sort=-pcpu | head -n $PROC_LIMIT >> $LOG_FILE
		echo -e "\nRelated Apache process status (`pgrep httpd | wc -l` processes):" >> $LOG_FILE
		apachectl fullstatus | tail -n +42 | head -n -12 >> $LOG_FILE
	else
		LOOP_CUR=$LOOP_IDLE
		#echo "Current load: "$cur_load
	fi
	sleep $LOOP_CUR;
done
