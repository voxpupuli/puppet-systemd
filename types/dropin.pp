# @summary custom datatype that validates filenames/paths for valid systemd dropin files
type Systemd::Dropin = Pattern['^[^/]+\.conf$']
