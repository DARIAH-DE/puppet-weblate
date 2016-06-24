# weblate config class
#
class weblate::config (
  $version          = $::weblate::version,
  $database         = $::weblate::database,
  $mysqlhost        = $::weblate::mysqlhost,
  $mysqlport        = $::weblate::mysqlport,
  $mysqldb          = $::weblate::mysqldb,
  $mysqluser        = $::weblate::mysqluser,
  $mysqlpassword    = $::weblate::mysqlpassword,
  $secretkey        = $::weblate::secretkey,
  $urlprefix        = $::weblate::urlprefix,
  $serveremail      = $::weblate::serveremail,
  $timezone         = $::weblate::timezone,
  $additionalconfig = $::weblate::additionalconfig,
){


  case $database {
    'mysql': {}
    default: { fail('DB type not supported by this module') }
  }

  file { '/opt/weblate/weblate/settings.py':
    ensure  => file,
    content => template('weblate/opt/weblate/weblate/settings.py.erb'),
  }

  exec { 'collectstatic':
    user      => 'www-data',
    creates   => '/opt/weblate/data/static',
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin','/usr/local/sbin'],
    command   => "bash -c 'source /opt/weblate/venv/bin/activate && ./manage.py collectstatic --noinput'",
    cwd       => '/opt/weblate',
    require   => [File['/opt/weblate/weblate/settings.py']],
    subscribe => Staging::Extract["Weblate-${version}.tar.gz"],
  }

}

