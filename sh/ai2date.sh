#!/bin/sh
# TEST ! VERY ALPHA STATE !
aide --update
cd /var/lib/aide && mv aide.db.new.gz aide.db.gz



command > file.tmp
mailx -s "Subject" mailaddress <file.tmp
rm file.tmp
