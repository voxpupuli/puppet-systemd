# @summary custom datatype that validates filenames/paths for valid systemd network files
type Systemd::Network = Pattern[/^[a-zA-Z0-9:\-_.\\@]+\.(network|netdev|link)$/]
