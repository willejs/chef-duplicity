include_recipe "yum::epel" if node["platform_family"] == "rhel"
include_recipe "build-essential"
include_recipe "python::package"

python_packages = value_for_platform(
  [ "amazon", "centos" ]  => { "default" => [ "python-boto", "python-httplib2", "python-oauth" ] },
  "default"   => [ "python-boto", "python-httplib2", "python-oauth" ]
)

system_packages = value_for_platform(
  [ "amazon", "centos" ]  => { "default" => [ "librsync-devel" ] },
  "default"   => [ "librsync-devel" ]
)

python_packages.concat(system_packages).each do |pkg|
  package pkg do
    action :install
  end
end

file "/etc/profile.d/duplicity.sh" do
  mode "0644"
  content ""
  action :nothing
end

ruby_block "python-path" do
  block do
    require "find"

    duplicity_profile = resources(:file => "/etc/profile.d/duplicity.sh")
    duplicity_profile.content "export PYTHONPATH='#{::Find.find(node["duplicity"]["dir"]).grep(/site-packages/).first}/'"
  end
  action :nothing
  notifies :create_if_missing, resources(:file => "/etc/profile.d/duplicity.sh"), :immediately
end

bash "install-duplicity" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xzf duplicity-#{node["duplicity"]["version"]}.tar.gz
    (cd duplicity-#{node["duplicity"]["version"]} &&
    python setup.py build --prefix=#{node["duplicity"]["dir"]}
    python setup.py install --prefix=#{node["duplicity"]["dir"]})
  EOH
  action :nothing
  notifies :create, resources(:ruby_block => "python-path"), :immediately
  not_if "#{node["duplicity"]["dir"]}/bin/duplicity --version 2>&1 | grep #{node["duplicity"]["version"]}"
end

remote_file "#{Chef::Config[:file_cache_path]}/duplicity-#{node["duplicity"]["version"]}.tar.gz" do
  source node["duplicity"]["url"]
  checksum node["duplicity"]["checksum"]
  notifies :run, resources(:bash => "install-duplicity"), :immediately
  action :create_if_missing
end
