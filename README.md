Apache load monitoring script
============================

# Description

This script is intended to be run on an Apache hosting server and it helps to 
indentify the exact domains that are causing the high load using Apache's
mod_status module. It dumps the information into a logfile for easy analysis,
shortening the interval of checks when it detects that the system load has
passed the preset threshold.

# Requirements
- Apache with mod_status enabled
- lynx / links

