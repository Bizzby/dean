
module Dean
  class ConfigurationHelper

    def all_environments
      raw_environments = symbolize_keys YAML.load_file Dir.pwd + '/.dean.yml'
      environments = []
      raw_environments[:environments].each do |environment|
        environments.push symbolize_keys environment
      end
      return environments
    end

    def build_settings_for_environment(environment)
      symbolize_keys environment[:build_settings]
    end

    def s3_settings_for_environment(environment)
      symbolize_keys environment[:s3_settings]
    end

    private

    def symbolize_keys(hash)
      Hash[hash.map { |key, value| [key.to_sym, value] }]
    end
  end
end