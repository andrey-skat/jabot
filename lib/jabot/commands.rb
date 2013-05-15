#encoding: utf-8

module Jabot
	class Commands

    class CommandNotExists < StandardError; end

		def initialize
			@commands_list = {}
		end

		def add_command(name, &block)
			@commands_list[name] = block unless command_exists? name
		end

		def command_exists?(command_name)
			@commands_list.include? command_name
    end

		def run(command_line)
      c = parse command_line
      unless command_exists? c[:name].downcase
        raise CommandNotExists, "command '#{c[:name]}' not found"
      end

      begin
			  @commands_list[ c[:name].downcase ].call( *c[:args] )
      rescue
        'Error while executing command'
      end
		end

		def parse(command_line)
			args = command_line.split
			{
					:name => args.shift.to_sym,
					:args => args
			}
    end

	end
end