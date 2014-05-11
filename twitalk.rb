
require 'twitter'
require 'yaml'
require 'tempfile'

require './client.rb'

yaml = YAML::load_file("./twitalk.conf.yaml")
PLAYER     = yaml["player"]
DICTIONARY = yaml["dictionary"]
VOICE      = yaml["voice"]


define_method :say do |text|
  temp = Tempfile::new("twitalk")
  temp.puts text.gsub("\n", " ")
  temp.close
  p "open_jtalk -m #{VOICE} -x #{DICTIONARY} -ow #{temp.path}.wav #{temp.path}"
  `open_jtalk -m #{VOICE} -x #{DICTIONARY} -ow #{temp.path}.wav #{temp.path}`
  `#{PLAYER} #{temp.path}.wav`
  temp.close(true)
end


def main
  client = Twitter::Streaming::Client.create_from_yaml_file("./client.conf.yaml")

  puts "Streaming..."
  client.user do |obj|
    if obj.is_a? Twitter::Tweet
      puts obj.text
      say  obj.text
    end
  end

rescue Interrupt
  `rm -r /tmp/twitalk*.wav`
end

main()
