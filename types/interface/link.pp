# interface definition
type Systemd::Interface::Link = Struct[{
    'Match'  => Optional[Systemd::Interface::Link::Match],
    'Link'   => Optional[Systemd::Interface::Link::Link],
    'SR-IOV' => Optional[Systemd::Interface::Link::Sr_iov],
}]
