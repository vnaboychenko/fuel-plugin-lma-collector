#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
define heka::output::http (
  $config_dir,
  $url,
  $encoder           = $title,
  $message_matcher   = 'FALSE',
  $username          = undef,
  $password          = undef,
  $timeout           = undef,
  $method            = 'POST',
  $headers           = {},
  $use_buffering     = true,
  $max_buffer_size   = 1024 * 1024 * 1024, # 1GiB
  $queue_full_action = 'drop',
  $max_file_size     = undef,
  $ensure            = present,
) {

  include heka::params

  validate_hash($headers)
  if $use_buffering {
    validate_buffering($max_buffer_size, $max_file_size, $queue_full_action)
  }

  file { "${config_dir}/output-${title}.toml":
    ensure  => $ensure,
    content => template('heka/output/http.toml.erb'),
    mode    => '0600',
    owner   => $heka::params::user,
    group   => $heka::params::user,
  }
}
