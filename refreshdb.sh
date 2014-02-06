ssh root@stockwatcher.co.nz stockwatcher/dump.sh
scp root@stockwatcher.co.nz:/tmp/stockwatcher-dump.sql ./
rm db/development.sqlite3 
sqlite3 -init stockwatcher-dump.sql db/development.sqlite3 .quit

