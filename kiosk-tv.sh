:'
	.COPYRIGHT
	CrossFit-Schaffhausen, 2021
	
	.WRITTEN BY
	Christoph Thurnheer
	
	.VERSION
	V 1.0.1-STABLE
	
	.DATED
	2021-06-16
		
        .SYNOPSIS
        Program to display CrossFit-Schaffhausen news on kiosk TV.

        .DESCRIPTION
        This code downloads a presentation and runs it full screen with libre office, automatically.
        
        .PREREQUISITES
        To execute the program, curl and exiftool is needed.
        sudo apt install curl
        sudo apt install exiftool
        
        .PARAMETER NAME
        No parameters required or accepted.

        .PARAMETER EXTENSION
        None, see above.

        .INPUTS
        None. You cannot pipe objects.

        .OUTPUTS
        None. No direct outputs, only debuging information.

        .EXAMPLE
	bash CFS.sh
	
	.STARTUP APPLICATION
	gnome-terminal -x bash -c "/home/cfs/Desktop/CFS.sh"

        .LINK
        wwww.crossfit-schaffhausen.ch

'
clear

#Global variables
	localpresentation="/home/cfs/Documents/CFS/CFS_Box_News.pptx"
	remotepresentation="https://www.dropbox.com/s/6s78jfgjt0deyjp/CFS_Box_News.pptx?dl=0"
	SleepSeconds=60

#Functions
	#Start presentation with $localpresentation in full scree mode, gather birth timestamp of current presentation (& = new process)
	function start_presentation () {
		echo "$(date): Starting presentation..."
		birthcurrentpresentation=$(exiftool -b -ModifyDate $localpresentation)
		libreoffice --norestore --show $localpresentation &
	}

	#Download presentation from URL with CURL to user's document folder (-s silent, -L follow redirects, -o output)
	function download_presentation () {
		echo "$(date): Starting download..."
		curl -s -L -o $localpresentation $remotepresentation
	}

	#Check if presentation is running (lsof checks processes), if not start up
	function check_presentation_running () {
		echo "$(date): Check if presentation is running..."
		if ! [[ $(lsof -t $localpresentation) ]]
		then
			echo "$(date): Presentation not running, call start_presentation"
			start_presentation
		else
			echo "$(date): Presentation is up and running, nothing to do!"
		fi
	}
		
	#Kill presentation process where filename of presentation is being used
	function kill_presentation () {
		echo "$(date): Killing presentation..."
		pkill -f $localpresentation
	}
	
	#Check if running presentation is older than new one, if true, kill and start again
	function check_latest_presentation_running () {
		echo "$(date): Check if latest presentation is running..."
		if [[ $birthcurrentpresentation < $(exiftool -b -ModifyDate $localpresentation) ]]
		then
			echo "$(date): Not latest presentation running, call kill_presentation!"
			kill_presentation
		else
			echo "$(date): Latest presentation already running, nothing to do!"
		fi
	}

#Main void
#Endless loop, download presentation, check for new presentation, check if latest presentation is running, sleep for n seconds
while true
do
	download_presentation
	check_latest_presentation_running
	check_presentation_running
	sleep $SleepSeconds
done
