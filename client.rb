
require "twitter"
require "yaml"

module ClientYAML
  def create_from_yaml_file(file)
    yaml = YAML::load_file(file)
    client = self.new
    client.consumer_key        = yaml["consumer_key"]
    client.consumer_secret     = yaml["consumer_secret"]
    client.access_token        = yaml["access_token"]
    client.access_token_secret = yaml["access_token_secret"]
    client
  end
end

class Twitter::Streaming::Client
	class << self
    include ClientYAML
  end
end

class Twitter::REST::Client
  class << self
    include ClientYAML
  end
end
