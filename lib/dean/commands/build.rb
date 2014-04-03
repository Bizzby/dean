require 'yaml'
require 'shenzhen'
require 'fileutils'
require 'plist'

module Dean
  class Build

    def build_all_environments
      configurations_helper = ConfigurationHelper.new
      configurations_helper.all_environments.each do |environment|
        build_environment environment
      end
    end

    def build_environment(environment)
      build_settings = ConfigurationHelper.new().build_settings_for_environment environment

      version = ProjectVersionHelper.new().version_from_plist environment[:plist]

      ipa_path = "#{Dir.pwd}/#{build_settings[:location]}/#{version}"

      if not build_configuration_exists? build_settings[:build_configuration]
        puts "Build configuration #{build_settings[:build_configuration]} does not exist!".red
        return
      end

      if not provisioning_profile_exists? build_settings[:provisioning_profile]
        puts "Provisioning profile #{build_settings[:provisioning_profile]} not found on disk!".red
        return
      end

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

        # Once build succeeded move .ipa and .dSYM in the proper folder
        FileUtils.mkdir_p ipa_path
        ipa_name = ipa_name_from_project build_settings[:project]
        dSYM_name = dSYM_name_from_project build_settings[:project]
        FileUtils.mv "#{Dir.pwd}/#{ipa_name}", "#{ipa_path}/#{ipa_name}"
        FileUtils.mv "#{Dir.pwd}/#{dSYM_name}", "#{ipa_path}/#{dSYM_name}"
      else
        puts "Skipping".yellow
      end
    end

    private

    def ipa_lookup(path)
      if Dir.exists? path
        puts "A build was found already. Do you wish to continue and override it? (y/n)"
        answer = $stdin.gets.chomp!
        return answer == 'y'
      else
        return true
      end
    end

    def build_configuration_exists?(build_configuration)
      # This is **very** dirty
      matches = `xcodeproj show Bizzby.xcodeproj --format hash | grep -w #{build_configuration} | wc -l`
      matches.to_i > 0
    end

    def provisioning_profile_exists?(profile)
      File.exists? "#{Dir.pwd}/#{profile}"
    end

    def ipa_name_from_project(project)
      File.basename(project, ".xcodeproj") + ".ipa"
    end

    def dSYM_name_from_project(project)
      File.basename(project, ".xcodeproj") + ".app.dSYM.zip"
    end
  end
end
