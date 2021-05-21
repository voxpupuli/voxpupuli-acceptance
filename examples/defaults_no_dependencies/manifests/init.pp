class defaults_no_dependencies {
  file { "/voxpupuli-acceptance-test":
    ensure  => 'file',
    content => "Current test: ${module_name}\n",
  }
}
