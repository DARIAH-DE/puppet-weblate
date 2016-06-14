# weblate config class
#
class weblate::config (
  $database      = $::weblate::database,
  $mysqlhost     = $::weblate::mysqlhost,
  $mysqlport     = $::weblate::mysqlport,
  $mysqldb       = $::weblate::mysqldb,
  $mysqluser     = $::weblate::mysqluser,
  $mysqlpassword = $::weblate::mysqlpassword,
  $secretkey     = $::weblate::secretkey,
  $urlprefix     = $::weblate::urlprefix,
  $serveremail   = $::weblate::serveremail,
){


  case $database {
    'mysql': {}
    default: { fail('DB type not supported by this module') }
  }

  file { '/opt/weblate/weblate/settings.py':
    ensure  => file,
    content => template('weblate/opt/weblate/weblate/settings.py.erb'),
  }

}

