# pg_install_repo
Yet enother postgres install scripts set.
# Compatibility
There is bash scripts tested on RHEL 6 only.
If you use other Linux Distro, something should not works
# Dependencies and auxilary tools
* _libevent_ requeried by _tmux_ and _pgbouncer_
* _tmux_ IMHO best console terminal multiplexer
* _pgbouncer_ Lightweight connection pooler for PostgreSQL
* _lsyncd_ inotify syncing daemon
# Install order
* libevent
* tmux
* PostgreSQL
* pgbouncer
* lsyncd
