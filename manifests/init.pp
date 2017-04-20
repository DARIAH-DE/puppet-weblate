# == Class: weblate
#
# Install weblate
#
# === Authors
#
# Carsten Thiel <thiel@sub.uni-goettingen.de>
#
# === Copyright
#
# Copyright 2016 SUB Göttingen, unless otherwise noted.
#
class weblate (
  $version                = $weblate::params::version,
  $debug_mode             = false,
  $data_dir               = undef,
  $manage_python          = false,
  $user                   = undef,
  $database               = undef,
  $mysqlhost              = 'localhost',
  $mysqlport              = '3306',
  $mysqldb                = undef,
  $mysqluser              = undef,
  $mysqlpassword          = undef,
  $registration_open      = true,
  $secretkey              = undef,
  $urlprefix              = undef,
  $serveremail            = 'root@localhost',
  $timezone               = $::timezone,
  $site_title             = 'Weblate',
  $enable_https           = false,
  $use_shibboleth         = false,
  $default_commiter_email = 'noreply@weblate.org',
  $default_commiter_name  = 'Weblate',
  $additionalconfig       = {},
) inherits weblate::params {

  anchor{ 'weblate::begin': }
  anchor{ 'weblate::end': }

  class { 'weblate::install':
    version        => $version,
    database       => $database,
    user           => $user,
    use_shibboleth => $use_shibboleth,
  }

  class { 'weblate::config':
    debug_mode             => $debug_mode,
    data_dir               => $data_dir,
    database               => $database,
    mysqlhost              => $mysqlhost,
    mysqlport              => $mysqlport,
    mysqldb                => $mysqldb,
    mysqluser              => $mysqluser,
    mysqlpassword          => $mysqlpassword,
    secretkey              => $secretkey,
    urlprefix              => $urlprefix,
    serveremail            => $serveremail,
    additionalconfig       => $additionalconfig,
    registration_open      => $registration_open,
    site_title             => $site_title,
    enable_https           => $enable_https,
    use_shibboleth         => $use_shibboleth,
    user                   => $user,
    default_commiter_email => $default_commiter_email,
    default_commiter_name  => $default_commiter_name,
  }

  if $manage_python {
    class { 'python' :
      version    => 'system',
      pip        => 'present',
      dev        => 'present',
      virtualenv => 'present',
      gunicorn   => 'absent',
    }
  }


  Anchor['weblate::begin'] ->
  Class['weblate::install']->
  Class['weblate::config']->
  Anchor['weblate::end']

}

