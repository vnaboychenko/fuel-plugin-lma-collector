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

class fuel_lma_collector::afds (
    $roles = undef,
    $node_cluster_roles = undef,
    $service_cluster_roles = undef,
    $node_cluster_alarms = undef,
    $service_cluster_alarms = undef,
    $alarms = undef,
){

    validate_array($roles)
    validate_hash($node_cluster_roles)
    validate_hash($service_cluster_roles)
    validate_hash($node_cluster_alarms)
    validate_hash($service_cluster_alarms)
    validate_array($alarms)

    $node_cluster_names_tmp = get_cluster_names($node_cluster_roles, $roles)
    $service_cluster_names = get_cluster_names($service_cluster_roles, $roles)

    if size($node_cluster_names_tmp) == 0 and $node_cluster_alarms['default'] {
        $node_cluster_names = ['default']
    } else {
        $node_cluster_names = $node_cluster_names_tmp
    }

    $node_afd_filters = get_afd_filters($node_cluster_alarms,
                                        $alarms,
                                        $node_cluster_names,
                                        'node')

    $service_afd_filters = get_afd_filters($service_cluster_alarms,
                                            $alarms,
                                            $service_cluster_names,
                                            'service')

    create_resources(lma_collector::afd_filter, $node_afd_filters)
    create_resources(lma_collector::afd_filter, $service_afd_filters)
}
