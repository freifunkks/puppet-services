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
  package { ['grafana']:
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
