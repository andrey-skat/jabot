#encoding: utf-8

require 'jabot/jabber'
require 'jabot/commands'

module Jabot

	class Base

		attr_reader :jabber, :commands

		def initialize
			load_config

			@jabber = Jabber.new client_id: @config[:client][:id], client_password: @config[:client][:password]
			@config[:remote_clients].each do |item|
				@jabber.add_remote_client item
			end

			@commands = Commands.new
		end

		def start_listen
			@jabber.listen do |m, sender_id|
				if @commands.exists?(m.body)
					result = @commands.run(m.body)
					@jabber.send sender_id, result unless result.empty?
				else
					@jabber.send sender_id, 'unknown command'
				end
			end
		end

		def load_config
			@config = YAML::load_file File.dirname(__FILE__) + '/config.yml'
		end
	end

	def self.start(&block)
		@base ||= Base.new
		self.commands { block } if block_given?
		@base.start_listen
	end

	def self.commands(&block)
		@base ||= Base.new
		@base.commands.register do
			block
		end
	end

end

=begin
Jabot::start do

	command :download_file do |url, save_path|
		spawn("wget -c '#{url}' '#{save_path}'")
	end

	command :hello do |name|
		"Hello, #{name}!"
	end

end
=end
