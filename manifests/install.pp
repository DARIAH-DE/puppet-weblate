# weblate install class
#
class weblate::install (
  $version        = $::weblate::version,
  $database       = $::weblate::database,
  $user           = $::weblate::user,
  $use_shibboleth = $::weblate::use_shibboleth,
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

  $weblate_dependencies = ['pytz', 'python-bidi', 'PyYaML', 'Babel', 'pyuca', 'pylibravatar', 'pydns', 'docutils']

  $weblate_dependencies.each |String $depen| {
    python::pip { $depen :
      ensure     => present,
      pkgname    => $depen,
      virtualenv => '/opt/weblate',
      owner      => $user,
    }
  }

  if $use_shibboleth {
    python::pip { 'django-shibboleth-remoteuser' :
      ensure     => present,
      owner      => $user,
      pkgname    => 'django-shibboleth-remoteuser',
      url        => 'git+https://github.com/Brown-University-Library/django-shibboleth-remoteuser.git',
      virtualenv => '/opt/weblate',
    }
  }

}

