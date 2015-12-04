###################
# Nginx Webserver #
###################
class webserver() {
  package { 'nginx':
    require => Exec['apt-update'],
    ensure => installed,
  }

  service { 'nginx':
    ensure   => running,
    provider => init,
    enable   => true,
  }

  exec { 'generate_dhparams':
    command => 'openssl dhparam -out /etc/nginx/dhparams.pem 2048',
    creates => '/etc/nginx/dhparams.pem',
  }

  file { '/var/www/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  file { '/etc/nginx/config-bits':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}

##########################
# Firmware Download Site #
##########################
class firmware_dl() {
  # TODO: Refactor!!!

  file { '/etc/nginx/config-bits/dl.ffks':
    ensure  => present,
    content => template('nginx/config-bits/dl.ffks'),
    mode    => 755,
  }

  file { '/etc/nginx/sites-available/dl.ffks':
    ensure  => present,
    content => template('nginx/sites/dl.ffks'),
    mode    => 755,
  }

  file { '/etc/nginx/sites-enabled/dl.ffks':
    ensure => 'link',
    target => '/etc/nginx/sites-available/dl.ffks',
  }

  file { '/etc/nginx/sites-available/dl.freifunk-kassel.de':
    ensure  => present,
    content => template('nginx/sites/dl.freifunk-kassel.de'),
    mode    => 755,
  }

  file { '/etc/nginx/sites-enabled/dl.freifunk-kassel.de':
    ensure => 'link',
    target => '/etc/nginx/sites-available/dl.freifunk-kassel.de',
  }
}

###############################
# Grafana: Network Monitoring #
###############################
class grafana(
  $debian_version='jessie'
) {
  apt::source { 'grafana':
    comment  => 'This repo includes a fastd release',
    location => 'deb https://packagecloud.io/grafana/stable/debian/',
    release  => $debian_version,
    repos    => 'main',
  }

  # install packages
  package { 'grafana':
    require => Exec['apt-update'],
    ensure => installed,
  }

  # grafana configuration
  file { '/etc/grafana/grafana.ini':
    ensure  => present,
    content => template('services/grafana.ini'),
    mode    => 755,
  }

  # Start services
  service { 'grafana':
    ensure   => running,
    provider => init,
    enable   => true,
  }
}

##############################
# Icinga: Service Monitoring #
##############################
class icinga() {

}

#######################
# Postgresql Database #
#######################
class postgres() {

}
