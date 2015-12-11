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
#
# == Class lma_collector::collectd::libvirt
#
# Class that configures collectd for collecting libvirt metrics.
#
# Note that the collectd plugin is configured to send the instance's UUID as
# the hostname of the collectd data.
#
# === Parameters:
#
# [*connection*]
#   (optional) The hypervisor connection URI. Default is 'qemu:///system'.
#
class lma_collector::collectd::libvirt (
  $connection = $lma_collector::params::libvirt_connection,
) inherits lma_collector::params {
  include lma_collector::collectd::service

  validate_string($connection)

  class { 'collectd::plugin::libvirt':
    connection      => $connection,
    hostname_format => 'uuid',
    notify          => Class['lma_collector::collectd::service']
  }
}
