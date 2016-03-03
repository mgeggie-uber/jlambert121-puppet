# document me
class puppet::params {

  $agent_version = 'latest'
  $ca_server = undef
  $use_srv_records = false
  $srv_domain = undef
  $runmode = 'cron'
  $environment = undef
  $puppetmaster = "puppet.${::domain}"

  $autosign = '/etc/puppetlabs/puppet/autosign.conf'
  $autosign_runnable = false
  $autosign_list     = []
  $autosign_script   = ''
  $dns_alt_names = undef
  $external_nodes = undef
  $fileserver_conf = undef
  $manage_hiera = true
  $node_terminus = 'plain'
  $hiera_source = undef
  $puppetdb = false
  $puppetdb_port = 8081
  $puppetdb_server = undef
  $puppetdb_version = 'latest'
  $manage_puppetdb = true
  $runinterval = '30m'
  $server_ca_enabled = true
  $server_certname = undef
  $server_java_opts = '-Xms2g -Xmx2g -XX:MaxPermSize=256m'
  $server_log_dir = '/var/log/puppetlabs/puppetserver'
  $server_log_file = 'puppetserver.log'
  $server_reports = undef
  $server_version = 'latest'
  $firewall = false
  $jruby_instances = $::processors[count]-1
  $use_legacy_auth = false

  $valid_node_termini = [ 'console', 'exec', 'plain' ]

  case $::osfamily {
    'Debian': {
      $server_config_dir = '/etc/default'
    }
    'RedHat': {
      $server_config_dir = '/etc/sysconfig'
    }
    default: {
      fail("${::osfamily} is not supported.")
    }
  }
}
