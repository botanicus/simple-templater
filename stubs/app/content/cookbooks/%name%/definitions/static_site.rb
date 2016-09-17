# encoding: utf-8

define(:static_site) do

  # Variables.
  root = node[:server][:root]

  # Create directories.
  directory root

  # Create vhost.conf for Nginx.
  template File.join(root, "vhost.conf") do
    source "vhost.conf.erb"
    variables root: root, server_names: params[:server_names], port: node[:server][:port]
  end

  # Restart Nginx.
  service "nginx" do
    action :restart
  end
end
