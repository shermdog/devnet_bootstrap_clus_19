service { 'firewalld.service':
  ensure => 'stopped',
  enable => 'false',
}

service { 'pe-puppetserver':
  ensure     => 'running',
  enable     => true,
  hasrestart => true,
  restart    => 'service pe-puppetserver reload',
}

file { '/root/.bash_profile':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  content => file(inline_template("<%= File.expand_path(File.dirname(__FILE__)) + '/bash_profile' %>")),
}

file_line { 'autosign':
  path => '/etc/puppetlabs/puppet/autosign.conf',
  line => '*',
}

file { '/etc/puppetlabs/code/environments/production/manifests/site.pp':
  ensure => file,
  owner  => 'pe-puppet',
  group  => 'pe-puppet',
  mode   => '0640',
  content => file(inline_template("<%= File.expand_path(File.dirname(__FILE__)) + '/site.pp' %>")),
}

package { 'puppet-bolt':
  ensure => 'present',
  source => 'http://yum.puppetlabs.com/puppet6/el/7/x86_64/puppet-bolt-1.21.0-1.el7.x86_64.rpm',
  provider => 'rpm',
}
