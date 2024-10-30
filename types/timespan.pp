# @summary Defines a timespan type
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
type Systemd::Timespan = Variant[
  Integer[0],
  Pattern[/^([0-9]+ *(usec|us|msec|ms|seconds?|sec|s|minutes?|min|m|hours?|hr|h|days?|d|weeks?|w|months?|M|years?|y)? *)+$/]
]
