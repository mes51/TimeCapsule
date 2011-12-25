# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "local"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

Bundler.setup

##
# Enable devel logging
#
Padrino::Logger::Config[:local] = { :log_level => :devel, :stream => :stdout }

##
# Add your before load hooks here
#
Padrino.before_load do
  TimeCapsuleEnv = YAML.load(File.open("config/config.yml"))
  Padrino.require_dependencies(Padrino.root + "/task/**/*.rb")
end

##
# Add your after load hooks here
#
Padrino.after_load do
  t = Thread.new do
    Clockwork.every 1.days, "post tweet", :at => "00:00" do
      PostTask.new.run
    end
    Clockwork.run
  end
end

Padrino.load!
