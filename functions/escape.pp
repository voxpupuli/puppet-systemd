# @summary Escape strings as systemd-escape does.
# @param input Input string
# @param path Use path (-p) ornon-path  style escaping.
# @return String
# @example Escaping a string
#   $result = systemd::escape('foo::bar')
# @example Escaping a path
#   $result = systemd::escape('/mnt/foobar',true)
function systemd::escape(String[1] $input, Boolean $path = false) >> String {
  # Escape method is defined
  # https://www.freedesktop.org/software/systemd/man/systemd.unit.html

  # fail path if . on end.
  if $path and $input[-1] == '.' {
    fail('A path can not end in a \'.\'')
  }

  # De-duplicate any `/` and prefix,suffix `/` if file
  if $path {
    $_chomped = $input.regsubst('/+$','').regsubst('^/+','').regsubst('//+','/')
  } else {
    $_chomped = $input
  }

  # Docs talk of escaping `:` also but seems not to be the case in reality.
  #
  $_output = $_chomped.map |$_i, $_token | {
    case $_token {
      '.': {
        $_escaped = $_i ? {
          0       => '\x2e',
          default => $_token,
        }
      }
      '/': { $_escaped = '-' }
      ',': { $_escaped = '\x2c' }
      '-': { $_escaped = '\x2d' }
      default: { $_escaped = $_token }
    }
    $_escaped
  }.join

  return $_output
}
