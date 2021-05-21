class defaults_fixtures {
  file { "/voxpupuli-acceptance-test":
    ensure  => 'file',
    content => "Current test: ${module_name}\n",
  }
}
