#encoding: utf-8

require 'xmpp4r/client'

module Jabot

	class Jabber
		include ::Jabber
    ::Jabber.debug = false

		attr_reader :remote_clients
    attr_reader :is_listen

		def initialize(options)
			@client_id = options[:client_id]
			@client_password = options[:client_password]

			@remote_clients = []
			@is_listen = false

      @client = Client::new JID::new(@client_id + '/bot')
      #@client.on_exception do
      #  puts 'Reconnect JabberClient';
      #  connect
      #end

			connect
    end

		def connect
			@client.connect
			@client.auth @client_password

			presence = Presence.new(:dnd, 'server running')
			@client.send presence
		end

		def disconnect
      @is_listen = false
			#@client.close
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
			@is_listen = true

      @message_callback = @client.add_message_callback 0, @message_callback do |m|
				if m.type != :error
					sender_id = "#{m.from.node}@#{m.from.domain}"
					puts' "Message received from "' + sender_id# + ": " + m.body
          unless m.body.nil?
            if @remote_clients.include?(sender_id)
              yield(m.body, sender_id) if block_given?
            else
              puts 'access denied'
            end
          end
        end
      end
    end

	end

end
