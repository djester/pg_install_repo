# PostgreSQL Install Repo
Yet enother PostgreSQL install from sources scripts set.
Made for personal use, but I making it more powerfull at near time.

# Compatibility
There is bash scripts tested on RHEL 6 only.

If you use other Linux Distro, something should not works

# Dependencies and auxilary tools
* __libevent__ - requeried by __tmux__ and __pgbouncer__
* __tmux__ - IMHO best console terminal multiplexer
* __pgbouncer__ - Lightweight connection pooler for PostgreSQL
* __lsyncd__ - inotify syncing daemon

# Install order
1. __libevent__ - need only for auxilary tools
2. __tmux__ - must have for each nix admin
3. __PostgreSQL__
4. __pgbouncer__ - if you want pooling for your connections
5. __lsyncd__ - if you have single node (without replication) you not need it

# Configuration
__config__ diriectory includes files with customizeble variables.

You should change it for your configuration 

# Installation
For installation you can use __pg_run_install.sh__ script.
I recommend to install __libevent__ and __tmux__ first.
After it other software could be installed from __tmux__.
Now scripts for install each component locate at __scripts__ directory

# Multiple instance
If you need multiple instance of PostgreSQL Cluster in same host (probably for testing purpose), you should create softlink to /etc/init.d/postgresql like postgresql.servername
Don't forget copy postgresql script from pg_install_repo/init.d before. Configure your server with command 
```
mkdir -p /etc/sysconfig/pgsql/

cat > /etc/sysconfig/pgsql/postgresql.servername <<EOF
PGDATA=/data/pgsql/9.4/
PGPORT=5432
PGLOG=/data/log/pgsql/pgstartup.servername.log
PGENGINE=/opt/postgresql/bin
EOF

ln -s /etc/init.d/postgresql /etc/init.d/postgresql.servername

```
