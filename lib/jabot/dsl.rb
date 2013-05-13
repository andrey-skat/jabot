
module Jabot
	module DSL
		def command(name, &block)
      @commands.add_command(name, &block)
		end

		def username(value)
			@config[:username] = value
		end

		def password(value)
			@config[:password] = value
		end

		def clients(list)
			raise StandardError, 'Clients list must be an array' unless list.is_a?(Array)
			@config[:clients] = list
		end
	end
end