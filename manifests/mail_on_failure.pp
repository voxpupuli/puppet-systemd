# mail on systemd units failing
#
# This class manages a set of scripts that helps to
# send out emails of failing units.
# It prepares a unit template that can then be referenced
# in units via OnFailure=status_email_USER@%n.service
#
# Email sending is handed over to sendmail and expected to
# be allowed for user nobody.
#
# This is helpful to monitor failing systemd.timers in a cron-like
# MAILTO style reporting.
# See https://wiki.archlinux.org/index.php/Systemd/Timers#MAILTO
# for background and implementation details.
#
# @param email_users
#   Users to prepare a template unit for.
#   By default this class prepares a template for root.
#   Besides local users you can also define an email address.
#   Due to the naming restrictionsof systemd units, the `@` in the template name
#   will be replaced with `_AT_` and `ALIAS@DOMAIN` will get a unit called:
#   `status_email_ALIAS_AT_DOMAIN@%n.service`
#
# @api public
#
class systemd::mail_on_failure (
  Array[String[1]] $email_users = ['root'],
) {
  file { '/usr/local/bin/systemd-email':
    content => file('systemd/systemd-email'),
    owner   => 'root',
    group   => 'systemd-journal',
    mode    => '0750',
  }
  $email_users.each |$user| {
    systemd::unit_file { "status_email_${user.regsubst(/@/,'_AT_','G')}@.service":
      content => epp('systemd/status_email@.service.epp', { user => $user }),
      require => File['/usr/local/bin/systemd-email'],
    }
  }
}
