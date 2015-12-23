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
1) libevent
2) tmux
3) PostgreSQL
4) pgbouncer
5) lsyncd
