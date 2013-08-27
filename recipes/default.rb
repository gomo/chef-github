#
# Cookbook Name:: github
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git" do
    action :install
end

directory node['github']['home'] + "/.ssh" do
	owner node['github']['user']
	group node['github']['user']
	mode 0700
end

bash "known host for github" do
	code "ssh-keyscan -H github.com >> " + node['github']['home'] + "/.ssh/known_hosts"
	user node['github']['user']
	not_if "su " + node['github']['user'] + " --c 'ssh-keygen -F github.com | grep -q \'github\.com\''"
end

cookbook_file node['github']['home'] + "/.ssh/github.id_rsa" do
	source "github.id_rsa"
	mode 0600
	owner node['github']['user']
	group node['github']['user']
end

template node['github']['home'] + '/.ssh/config' do
	action 'create_if_missing'
	source 'ssh.config.erb'
	owner node['github']['user']
	group node['github']['user']
	mode 0600
end

#Config for git
template node['github']['home'] + '/.gitconfig' do
	action 'create_if_missing'
	source 'gitconfig.erb'
	owner node['github']['user']
	group node['github']['user']
	mode 0644
	variables(
		:email => node['github']['git_email'],
		:name => node['github']['git_name']
	)
end