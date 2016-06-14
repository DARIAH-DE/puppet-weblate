# weblate install class
#
class weblate::install (
  $version  = $::weblate::version,
  $database = $::weblate::database,
){

  staging::file { "Weblate-${version}.tar.gz":
    source => "http://dl.cihar.com/weblate/Weblate-${version}.tar.gz",
  }->
  staging::extract { "Weblate-${version}.tar.gz":
    target  => '/opt',
    creates => "/opt/Weblate-${version}",
  }
  file { '/opt/weblate':
    ensure => link,
    target => "/opt/Weblate-${version}",
  }

  python::virtualenv { '/opt/weblate' :
    ensure       => present,
    version      => 'system',
    requirements => '/opt/weblate/requirements.txt',
    venv_dir     => '/opt/weblate/venv',
    cwd          => '/opt/weblate',
    timeout      => 0,
    require      => Staging::Extract["Weblate-${version}.tar.gz"],
  }

  if ($database == 'mysql') {
    python::pip { 'mysql' :
      ensure     => present,
      pkgname    => 'MySQL-python',
      virtualenv => '/opt/weblate/venv',
    }
  }


}

