# weblate install class
#
class weblate::install (
  $version  = $::weblate::version,
  $database = $::weblate::database,
  $user     = $::weblate::user,
){

  python::virtualenv { '/opt/weblate' :
    ensure  => present,
    version => 'system',
    owner   => $user,
    timeout => 0,
  }

  if ($database == 'mysql') {
    python::pip { 'mysql' :
      ensure     => present,
      pkgname    => 'MySQL-python',
      virtualenv => '/opt/weblate',
      owner      => $user,
    }
  }

  python::pip { 'siphashc3' :
    ensure     => latest,
    pkgname    => 'siphashc3',
    virtualenv => '/opt/weblate',
    owner      => $user,
  }->
  python::pip { 'Weblate' :
    ensure     => $version,
    pkgname    => 'Weblate',
    virtualenv => '/opt/weblate',
    owner      => $user,
  }


  $weblate_dependencies = ['pytz', 'python-bidi', 'PyYaML', 'Babel', 'pyuca', 'pylibravatar', 'pydns']

  $weblate_dependencies.each |String $depen| {
    python::pip { $depen :
      ensure     => present,
      pkgname    => $depen,
      virtualenv => '/opt/weblate',
      owner      => $user,
    }
  }

  #  file { '/opt/weblate/data':
  #    ensure  => directory,
  #    owner   => $user,
  #    require => Staging::Extract["Weblate-${version}.tar.gz"],
  #  }

}

