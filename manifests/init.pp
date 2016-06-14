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
  $version       = $weblate::params::version,
  $manage_python = false,
  $database      = undef,
) inherits weblate::params {

  anchor{ 'weblate::begin': }
  anchor{ 'weblate::end': }

  class { 'weblate::install':
    version  => $version,
    database => $database,
  }

  class { 'weblate::config':
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
