require 'thor'

module Dean
  module Cli
    class Application < Thor

      desc 'bump_version VALUE', 'Bump the given version VALUE of the project'
      def bump(value)
        plists = []
        Dean::ConfigurationHelper.new.all_environments.each do |environment|
          plists.push environment[:plist]
        end
        old_version = Dean::ProjectVersionHelper.new.version_from_plist plists[0]

        Dean::VersionBumper.new.bump_all_environments value.to_sym

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

      desc 'deploy', 'Deploy the app. Builds AND distributes the app'
      def deploy()
        Dean::ConfigurationHelper.new.all_environments.each do |environment|
          begin
            Dean::Build.new.build_environment environment
            Dean::Upload.new.upload_environment environment
          rescue Exception => e
            log_exception e
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
