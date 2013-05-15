#encoding: utf-8

require 'jabot/jabber'
require 'jabot/commands'
require 'jabot/dsl'

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
      @standalone_mode = false
    end

		def configure(&block)
			@commands = Commands.new
      standard_commands
      instance_eval(&block)

      @jabber = Jabber.new client_id: @config[:username], client_password: @config[:password]
      @config[:clients].each do |item|
        @jabber.add_remote_client item
      end
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

      if @standalone_mode
        puts 'Start listening...'
        loop do
          break unless @jabber.is_listen
        end
      end
    end

    #add standard commands
    def standard_commands
      command :quit do
        @jabber.stop
      end
    end
	end

  #start jabot
  #
  #Example:
  #Jabot.start do
  #  standalone_mode
  #
  #  username 'username@jabber.com'
  #  password '*****'
  #  clients %w{client@jabber.com}
  #
  #  command :download_file do |url, save_path|
  #    spawn("wget -c -O '#{save_path}' '#{url}'")
  #  end
  #
  #  command :hello do
  #    'Hello!'
  #  end
  #end
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