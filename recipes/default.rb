#
# Cookbook Name:: oracle-instantclient
# Recipe:: default
#
# Copyright (C) 2013 Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
remote_file File.join(Chef::Config[:file_cache_path], node['oracle-instantclient']['basic-rpm']) do
  source node['oracle-instantclient']['public-url'] + node['oracle-instantclient']['basic-rpm']
  action :create
  checksum node['oracle-instantclient']['basic-sha256']
end

alien_convert File.join(Chef::Config[:file_cache_path], node['oracle-instantclient']['basic-rpm']) do
  action :install
  only_if { platform_family? 'debian' }
end

alien_package 'oracle-instantclient12.1-basic' do
  source File.join(Chef::Config[:file_cache_path], node['oracle-instantclient']['basic-rpm'])
  action :install
end
