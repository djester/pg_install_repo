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
_config_ diriectory includes files with customizeble variables.

You should change it for your configuration 
