class defaults_facts {
  file { "/voxpupuli-acceptance-test":
    ensure  => 'file',
    content => "Current test: ${module_name}\nThe answer: ${facts['the_answer']}\n",
  }
}
