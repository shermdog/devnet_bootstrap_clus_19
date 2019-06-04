file { '/root/.puppetlabs/bolt/Puppetfile':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0640',
  content => file(inline_template("<%= File.expand_path(File.dirname(__FILE__)) + '/bolt/Puppetfile' %>")),
}

file { '/root/.puppetlabs/bolt/inventory.yaml':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0640',
  content => file(inline_template("<%= File.expand_path(File.dirname(__FILE__)) + '/bolt/inventory.yaml' %>")),
}