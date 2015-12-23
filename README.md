# pg_install_repo
Yet enother postgres install scripts set.
# Compatibility
There is bash scripts tested on RHEL 6 only.
If you use other Linux Distro, something should not works
# Dependencies and auxilary tools
*libevent* requeried by tmux and pgbouncer
*tmux* IMHO best console terminal multiplexer
*pgbouncer* Lightweight connection pooler for PostgreSQL
*lsyncd* inotify syncing daemon
# Install order
* libevent
* tmux
* PostgreSQL
* pgbouncer
* lsyncd
