require 'yaml'

module Dean
  class Build

    def build
      configurations = symbolize_keys YAML.load_file Dir.pwd + '/.deanrc'
      configurations[:environments].each do |environment|
        environment = symbolize_keys environment
        puts environment[:name]
      end
    end

    private

    def symbolize_keys(hash)
      Hash[hash.map { |key, value| [key.to_sym, value] }]
    end
  end
end
