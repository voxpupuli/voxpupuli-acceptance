class defaults_serverspec {
  package {'nginx':
    ensure => present
  }
  service {'nginx':
    ensure => running
  }
}
