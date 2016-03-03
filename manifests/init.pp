#
class puppet (
  Boolean                                      $agent             = true,
  Boolean                                      $server            = false,
  String                                       $agent_version     = $::puppet::params::agent_version,
  Optional[String]                             $ca_server         = $::puppet::params::ca_server,
  Boolean                                      $use_srv_records   = $::puppet::params::use_srv_records,
  Optional[String]                             $srv_domain        = $::puppet::params::srv_domain,
  Enum['cron', 'service', 'none']              $runmode           = $::puppet::params::runmode,
  Optional[String]                             $environment       = $::puppet::params::environment,
  String                                       $puppetmaster      = $::puppet::params::puppetmaster,

  # Server
  String                                       $autosign          = $::puppet::params::autosign,
  Boolean                                      $autosign_runnable = $::puppet::params::autosign_runnable,
  Optional[Array[String]]                      $autosign_list     = $::puppet::params::autosign_list,
  Optional[String]                             $autosign_script   = $::puppet::params::autosign_script,
  Optional[Array[String]]                      $dns_alt_names     = $::puppet::params::dns_alt_names,
  Optional[String]                             $external_nodes    = $::puppet::params::external_nodes,
  Optional[Hash[String, Hash[String, String]]] $fileserver_conf   = $::puppet::params::fileserver_conf,
  Boolean                                      $manage_hiera      = $::puppet::params::manage_hiera,
  String                                       $node_terminus     = $::puppet::params::node_terminus,
  Optional[Pattern[/\Apuppet/]]                $hiera_source      = $::puppet::params::hiera_source,
  Boolean                                      $puppetdb          = $::puppet::params::puppetdb,
  Integer                                      $puppetdb_port     = $::puppet::params::puppetdb_port,
  Optional[String]                             $puppetdb_server   = $::puppet::params::puppetdb_server,
  String                                       $puppetdb_version  = $::puppet::params::puppetdb_version,
  Boolean                                      $manage_puppetdb   = $::puppet::params::manage_puppetdb,
  String                                       $runinterval       = $::puppet::params::runinterval,
  Boolean                                      $server_ca_enabled = $::puppet::params::server_ca_enabled,
  Optional[String]                             $server_certname   = $::puppet::params::server_certname,
  String                                       $server_java_opts  = $::puppet::params::server_java_opts,
  String                                       $server_log_dir    = $::puppet::params::server_log_dir,
  String                                       $server_log_file   = $::puppet::params::server_log_file,
  Optional[Array[String]]                      $server_reports    = $::puppet::params::server_reports,
  String                                       $server_version    = $::puppet::params::server_version,
  Boolean                                      $firewall          = $::puppet::params::firewall,
  Integer                                      $jruby_instances   = $::puppet::params::jruby_instances,
  Boolean                                      $use_legacy_auth   = $::puppet::params::use_legacy_auth,
) inherits puppet::params {

  if $puppetdb and !$puppetdb_server {
    fail('Puppet: puppetdb_server is required with puppetdb')
  }

  if $fileserver_conf and !is_hash($fileserver_conf) {
    fail('Puppet: fileserver_conf must be a of hash of mountpoints')
  }

  if $autosign_runnable == true and $autosign_script == '' {
    fail('Puppet: autosign_runnable requires autosign_script')
  }

  if is_array($autosign_list) and !empty($autosign_list) and $autosign_script != '' {
    fail('Puppet: autosign_list and autosign_script can not both be specified')
  }

  unless $node_terminus in $::puppet::params::valid_node_termini {
    fail("Puppet: node_terminus must be one of ${::puppet::params::valid_node_termini}" )
  }

  if $node_terminus == 'exec' and ! is_string($external_nodes) {
    fail('Puppet: node_terminus = exec requires external_nodes be set to a executable path')
  }

  if ( $agent or $server ) {
    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }

  if ($server and $runmode == 'service') {
    Service['puppetserver'] -> Service['puppet']
  }

  class { '::puppet::common': }

  class { '::puppet::server':
    require => Class['puppet::common'],
  } ->

  class { '::puppet::agent':
    require => Class['puppet::common'],
  }

}
