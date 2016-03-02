# recipes/service.rb
#
# Copyright 2013, Simple Finance Technology Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

executable_path = ::File.join(node[:zookeeper][:install_dir],
                              "zookeeper-#{node[:zookeeper][:version]}",
                              'bin',
                              'zkServer.sh')

case node.platform
when "ubuntu"
 if node.platform_version.to_f <= 14.04
   node[:zookeeper][:service_style] = "init"
 end
end


service_name="zookeeper"

case node.platform_family
  when "debian"
systemd_script = "/lib/systemd/system/#{service_name}.service"
  when "rhel"
systemd_script = "/usr/lib/systemd/system/#{service_name}.service" 
end


case node[:zookeeper][:service_style]
when 'upstart'
  template '/etc/default/zookeeper' do
    source 'environment-defaults.erb'
    owner 'zookeeper'
    group 'zookeeper'
    action :create
    mode '0644'
    notifies :restart, 'service[zookeeper]', :delayed
  end
  template '/etc/init/zookeeper.conf' do
    source 'zookeeper.init.erb'
    owner 'root'
    group 'root'
    action :create
    mode '0644'
    notifies :restart, 'service[zookeeper]', :delayed
  end
  service 'zookeeper' do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action :enable
  end
when 'systemd'

  template '/etc/default/zookeeper' do
    source 'environment-defaults.erb'
    owner 'zookeeper'
    group 'zookeeper'
    action :create
    mode '0644'
    notifies :restart, 'service[zookeeper]', :delayed
  end
  template systemd_script do
    source 'zookeeper.systemd.erb'
    owner 'root'
    group 'root'
    action :create
    mode '0644'
    notifies :restart, 'service[zookeeper]', :delayed
  end
  service 'zookeeper' do
    provider Chef::Provider::Service::Systemd
    supports :status => true, :restart => true, :reload => true
    action :enable
  end


when 'runit'
  # # runit_service does not install runit itself
  # include_recipe "runit"

  # runit_service 'zookeeper' do
  #   default_logger true
  #   options(
  #     exec: executable_path
  #   )
  #   action [:enable, :start]
  # end
when 'init'
  template '/etc/default/zookeeper' do
    source 'environment-defaults.erb'
    owner 'zookeeper'
    group 'zookeeper'
    action :create
    mode '0644'
    notifies :restart, 'service[zookeeper]', :delayed
  end
  template '/etc/init.d/zookeeper' do
    source 'zookeeper.initd.erb'
    owner 'root'
    group 'root'
    action :create
    mode '0755'
    notifies :restart, 'service[zookeeper]', :delayed
  end
  service 'zookeeper' do
    provider Chef::Provider::Service::Init::Debian
    supports :status => true, :restart => true, :reload => true
    action :enable
  end
when 'exhibitor'
  Chef::Log.info('Assuming Exhibitor will start up Zookeeper.')
else
  Chef::Log.error('You specified an invalid service style for Zookeeper, but I am continuing.')
end
