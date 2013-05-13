#encoding: utf-8

require_relative 'jabot/jabber'
require_relative 'jabot/commands'
require_relative 'jabot/dsl'

module Jabot

	class Base
    include Jabot::DSL

		attr_reader :jabber, :commands
		attr_accessor :config

		def initialize
			@config = {
					username: '',
			    password: '',
          clients: []
			}
    end

		def configure(&block)
			@commands = Commands.new
      instance_eval(&block)

      @jabber = Jabber.new client_id: @config[:username], client_password: @config[:password]
      @config[:clients].each do |item|
        @jabber.add_remote_client item
      end
		end

		def start_listen
			@jabber.listen do |m, sender_id|
				if @commands.exists?(m.body)
					result = @commands.run(m.body)
					@jabber.send sender_id, result unless result.nil? || result.empty?
				else
					@jabber.send sender_id, 'unknown command'
				end
			end
		end
	end

	def self.start(&block)
		@base = Base.new
    @base.configure(&block)
		@base.start_listen
	end

end

