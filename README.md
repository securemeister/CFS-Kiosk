# CFS-Kiosk

Disable System Reporting (used when RaPi is being shut down with cut off power cord);

$ sudo sed -i 's/^enabled=1/enabled=0/' /etc/default/apport
$ sudo cat /etc/default/apport 
# set this to 0 to disable apport, or to 1 to enable it
# you can temporarily override this with
# sudo service apport start force_start=1
enabled=0
