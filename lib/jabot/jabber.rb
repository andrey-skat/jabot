#encoding: utf-8

require 'xmpp4r/client'

module Jabot

	class Jabber
		include ::Jabber
    ::Jabber.debug = true

		attr_reader :remote_clients
		attr_accessor :is_listen

		def initialize(options)
			@client_id = options[:client_id]
			@client_password = options[:client_password]

			@remote_clients = []
			@is_listen = false

			connect
    end

		def connect
			@client = Client::new JID::new(@client_id + "/bot")
			@client.connect
			@client.auth @client_password

			presense = Presence.new(:dnd, "server running")
			@client.send presense
		end

		def disconnect
			@client.close
		end

		def add_remote_client(id)
			@remote_clients << id unless @remote_clients.include?(id)
		end

		def send_to_all(text)
			@remote_clients.each do |to|
				send to, text
			end
		end

		def send(to, text)
			message = Message::new to, text
			@client.send message
		end

		def listen
			puts "Start listen..."
			@is_listen = true

			@client.add_message_callback do |m|
				if m.type != :error
					sender_id = m.from.node + "@" + m.from.domain
					puts "Message received from " + sender_id# + ": " + m.body
          unless m.body.nil?
            if @remote_clients.include?(sender_id)
              yield(m, sender_id) if block_given?
            else
              puts 'access denied'
            end
          end
				else
					puts "error message"
				end
			end

			loop do
				break if gets.chomp == "quit" || !@is_listen
			end
		end

	end

end
