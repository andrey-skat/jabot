#encoding: utf-8

module Jabot
	class Commands

		def initialize
			@commands_list = {}
		end

		def add_command(name, &block)
			@commands_list[name] = block unless @commands_list.include?(name)
		end

		def exists?(command_line)
			@commands_list.include?(parse(command_line)[:name])
		end

		def run(command_line)
			c = parse command_line
			@commands_list[c[:name]].call(*c[:args])
		end

		def parse(command_line)
			args = command_line.split
			{
					:name =>  args.shift.to_sym,
					:args => args
			}
		end

	end
end