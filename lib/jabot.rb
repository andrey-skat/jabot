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

      standard_commands
		end

		def start_listen
      @jabber.listen do |message, sender_id|
        begin
          result = @commands.run(message)
          @jabber.send sender_id, result if result.is_a?(String) && !result.empty?
        rescue Commands::CommandNotExists => e
          @jabber.send sender_id, e.message
        end
      end
      loop do
        break unless @jabber.is_listen
      end
    end

    def standard_commands
      command :quit do
        @jabber.disconnect
      end
      command :help do
      end
    end
	end

	def self.start(&block)
		@base = Base.new
    @base.configure(&block)
		@base.start_listen
  end

end

module REXML
  class IOSource
    def match(pattern, cons = false)
      @buffer = @buffer.force_encoding('utf-8')
      super(pattern, cons)
    end
  end
end