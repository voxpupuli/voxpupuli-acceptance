class defaults_basic_dependency (
  Enum['present', 'absent'] $ensure = 'present',
) {
  $data = {'current_test' => $module_name}
  file { "/voxpupuli-acceptance-test":
    ensure  => bool2str($ensure == 'present', 'file', 'absent'),
    content => to_json($data),
  }
}
