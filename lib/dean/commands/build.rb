require 'yaml'
require 'shenzhen'
require 'fileutils'
require 'plist'

module Dean
  class Build

    def build_all_environments
      configurations = symbolize_keys YAML.load_file Dir.pwd + '/.dean.yml'
      configurations[:environments].each do |environment|
        environment = symbolize_keys environment
        build_environment environment
      end
    end

    def build_environment(environment)
      # Extract version info
      plist_path = "#{Dir.pwd}/#{environment[:plist]}"

      if not File.exists? plist_path
        puts "Cannot open #{plist_path}. File not found"
        return
      end

      plist = Plist::parse_xml plist_path
      version = plist["CFBundleShortVersionString"]

      build_settings = symbolize_keys environment[:build_settings]

      ipa_path = "#{Dir.pwd}/#{build_settings[:location]}/#{version}"

      if ipa_lookup ipa_path
        puts "Going to build app for #{environment[:name]}"

        build_options = "--workspace #{build_settings[:workspace]}"
        build_options += " --project #{build_settings[:project]}"
        build_options += " -c #{build_settings[:build_configuration]}"
        build_options += " -s #{build_settings[:scheme]}"
        build_options += " -m #{build_settings[:provisioning_profile]}"
        build_options += " --clean"
        build_options += " --archive"

        system "ipa build #{build_options}"
        # puts "FAKE ipa build #{build_options}"

        #
        # TODO this shouldn't be static, but I need more time to think about how to structure it
        #
        # Once build succed move .ipa and .dSYM in the proper folder
        FileUtils.mkdir_p ipa_path
        FileUtils.mv "#{Dir.pwd}/Bizzby.ipa", "#{ipa_path}/Bizzby.ipa"
        FileUtils.mv "#{Dir.pwd}/Bizzby.app.dSYM.zip", "#{ipa_path}/Bizzby.app.dSYM.zip"
      else
        puts "Skipping"
      end
    end

    private

    def symbolize_keys(hash)
      Hash[hash.map { |key, value| [key.to_sym, value] }]
    end

    def ipa_lookup(path)
      if Dir.exists? path
        puts "A build was found already. Do you wish to continue and override it? (y/n)"
        answer = $stdin.gets.chomp!
        return answer == 'y'
      else
        return true
      end
    end
  end
end
