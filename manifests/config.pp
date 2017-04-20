# weblate config class
#
class weblate::config (
  $version                = $::weblate::version,
  $debug_mode             = $::weblate::debug_mode,
  $data_dir               = $::weblate::data_dir,
  $database               = $::weblate::database,
  $mysqlhost              = $::weblate::mysqlhost,
  $mysqlport              = $::weblate::mysqlport,
  $mysqldb                = $::weblate::mysqldb,
  $mysqluser              = $::weblate::mysqluser,
  $mysqlpassword          = $::weblate::mysqlpassword,
  $secretkey              = $::weblate::secretkey,
  $urlprefix              = $::weblate::urlprefix,
  $serveremail            = $::weblate::serveremail,
  $timezone               = $::weblate::timezone,
  $additionalconfig       = $::weblate::additionalconfig,
  $registration_open      = $::weblate::registration_enabled,
  $site_title             = $::weblate::site_title,
  $enable_https           = $::weblate::enable_https,
  $use_shibboleth         = $::weblate::use_shibboleth,
  $default_commiter_email = $::weblate::default_commiter_email,
  $default_commiter_name  = $::weblate::default_commiter_name,
){

  case $database {
    'mysql': {}
    default: { fail('DB type not supported by this module') }
  }

  file { '/opt/weblate/lib/python2.7/site-packages/weblate/settings.py':
    ensure  => file,
    owner   => 'www-data',
    content => template('weblate/opt/weblate/settings.py.erb'),
    notify  => Service['apache2'],
  }

  exec { 'weblate-dbmigrate':
    user        => 'www-data',
    refreshonly => true,
    path        => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin','/usr/local/sbin'],
    command     => "bash -c 'source /opt/weblate/bin/activate && export DJANGO_SETTINGS_MODULE=weblate.settings && weblate migrate'",
    cwd         => '/opt/weblate',
    require     => [File['/opt/weblate/lib/python2.7/site-packages/weblate/settings.py']],
    subscribe   => [Python::Pip['Weblate']],
  }

  if $use_shibboleth {
    $_shib_urlpatterns = present
  } else {
    $_shib_urlpatterns = absent
  }

  file_line { 'weblate_urls.py':
    ensure => $_shib_urlpatterns,
    path   => '/opt/weblate/lib/python2.7/site-packages/weblate/urls.py',
    line   => "urlpatterns += [ url(r'^shib/', include('shibboleth.urls', namespace='shibboleth')), ]",
  }

}

