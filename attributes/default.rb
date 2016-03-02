
default[:zookeeper][:version]     = '3.4.7'
default[:zookeeper][:checksum]    = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default[:zookeeper][:mirror]      = 'http://snurran.sics.se/hops/'
default[:zookeeper][:user]        = 'zookeeper'
default[:zookeeper][:install_dir] = '/opt/zookeeper'
default[:zookeeper][:use_java_cookbook] = true

# One of: 'upstart', 'runit', 'exhibitor'
default[:zookeeper][:service_style] = 'systemd'

default[:zookeeper][:config] = {
  clientPort: 2181,
  dataDir: '/var/lib/zookeeper',
  tickTime: 2000
}
