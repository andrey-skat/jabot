Jabot is a jabber bot that provides DSL for configuration.

### Installation

```sh
$ gem install jabot
```

Or with Bundler in your Gemfile.

```ruby
gem 'jabot'
```

### Example bot.rb file

```ruby
require 'jabot'

Jabot.start do
    #if you are running in console, this is start a main loop
    standalone_mode

    username 'username@jabber.com'
    password '*****'
    #clients who allowed to send commands
    clients %w{client@jabber.com}

    #example in messenger
    #me: download_file 'http://example.com/image.jpg' '/home/user/image.jpg'
    command :download_file do |url, save_path|
      spawn("wget -c -O '#{save_path}' '#{url}'")
    end

    #if it returns not empty string, it's sent to you
    command :hello do
      'Hello!'
    end
end
```