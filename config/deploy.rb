require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
#load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "swgrade.hanyang.ac.kr:8022", :web, :app, :db, primary: true

set :gateway, 'swadmin@calab.hanyang.ac.kr:8022'
set :user, "deployer"
set :application, "skynet"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "http://github.com/darkzin/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = 8022

after "deploy", "deploy:cleanup" # keep only the last 5 releases
