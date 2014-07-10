require 'thor'

module Dean
  module Cli
    class Application < Thor

      desc 'bump_version VALUE', 'Bump the given version VALUE of the project'
      def bump(value, name=nil)
        plists = []
        Dean::ConfigurationHelper.new.all_environments.each do |environment|
          plists.push environment[:plist]
        end
        old_version = Dean::ProjectVersionHelper.new.version_from_plist plists[0]

        Dean::VersionBumper.new.bump_all_environments value.to_sym, name

        # commit and tag, here only for the moment!
        new_version = Dean::ProjectVersionHelper.new.version_from_plist plists[0]
        message = "Do you want to commit the changes to the version (#{old_version} -> #{new_version})?"
        Dean::GitHelper.new.commit_asking_user(message, new_version, plists)
      end

      desc 'build', 'Builds the ipa'
      def build()
        begin
          Dean::Build.new.build_all_environments
        rescue Exception => e
          log_exception e
        end

      end

      desc 'distribute', 'Distribute the app. (Now only uploads the ipa to the S3 server)'
      def distribute()
        Dean::Upload.new.upload_all_environments
      end

      desc 'deploy ENV', 'Deploy the app. Builds AND distributes the app. An optional environment name can be passed to deploy only one environment'
      def deploy(environment_name=nil)
        Dean::ConfigurationHelper.new.all_environments.each do |environment|
          if environment_name != nil
            if environment_name == environment[:name]
              begin
                Dean::Build.new.build_environment environment
                Dean::Upload.new.upload_environment environment
              rescue Exception => e
                log_exception e
              end
            end
          else
            begin
              Dean::Build.new.build_environment environment
              Dean::Upload.new.upload_environment environment
            rescue Exception => e
              log_exception e
            end
          end
        end
      end

      private

      def log_exception(exception)
        puts "Something went wrong!".red
        puts "#{exception.message}".red
      end
    end
  end
end
