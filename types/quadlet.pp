# @summary custom datatype that validates different filenames for quadlet units
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html https://www.freedesktop.org/software/systemd/man/systemd.unit.html
type Systemd::Quadlet = Pattern[/^[a-zA-Z0-9:\-_.\\@%]+\.(container|volume|network|kube|image|build|pod)$/]
