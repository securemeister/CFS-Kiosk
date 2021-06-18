# CFS-Kiosk

Disable System Reporting (used when RaPi is being shut down with cut off power cord);

$ sudo sed -i 's/^enabled=1/enabled=0/' /etc/default/apport
$ sudo cat /etc/default/apport
