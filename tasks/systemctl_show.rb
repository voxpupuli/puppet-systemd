#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'

params  = JSON.parse($stdin.read)

systemctl_cmd = params['bin_path']
systemctl_args = ['show', '--no-pager', '--no-legend', '--property', params['properties'].join(','), params['unit_name']]
output, status = Open3.capture2(systemctl_cmd, *systemctl_args)

raise "Error running systemctl show: #{output}" unless status.success?

puts output.split("\n").to_h { |item| item.split('=', 2) }.to_json
