# Cookbook Name:: oracle-instantclient
# Provider:: AlienConvert
# Author:: David Kinzer <dtkinzer@gmail.com>
#
# Copyright (C) 2014 David Kinzer
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

require 'chef/provider/execute'
require_relative 'mixin_alien_converter'

class Chef
  class Provider
    # Provides the default functionality for the alien_convert resource.
    class AlienConvert < Chef::Provider::Execute
      include Chef::Mixin::AlienConverter

      def initialize(new_resource, run_context)
        super
        Chef::Log.info("Run Context #{run_context}")
        new_resource.cwd package_directory
        new_resource.command  command
        new_resource.creates package_debian_source
      end

      def action_convert
        if sentinel_file_if_exists
          Chef::Log.debug("#{@new_resource} sentinel file #{sentinel_file} exists - nothing to do")
          return false
        end

        converge_by("alien_convert #{@new_resource.name}") do
          shell_out!(@new_resource.command, options)
          Chef::Log.info('Alien conversion successful.')
        end
      end

      def options
        opts = {}
        opts[:timeout] = @new_resource.timeout || 3600
        opts[:returns] = @new_resource.returns
        opts[:environment] = @new_resource
        opts[:user] = @new_resource
        opts[:group] = @new_resource.group
        opts[:cwd] = @new_resource.cwd
        opts[:umask] = @new_resource.umask
        opts.delete_if { |k, v| v.nil? }
      end
    end
  end
end