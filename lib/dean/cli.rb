require 'thor'

module Dean
  module Cli
    class Application < Thor

      desc 'bump_version VALUE', 'Bump the given version VALUE of the project'
      def bump(value)
        Dean::VersionBumper.new.bump_all_environments value.to_sym
      end

      desc 'build', 'Builds the ipa'
      def build()
        Dean::Build.new.build_all_environments
      end

      desc 'distribute', 'Distribute the app. (Now only uploads the ipa to the S3 server)'
      def distribute()
        Dean::Upload.new.upload_all_environments
      end

      desc 'deploy', 'Deploy the app. Builds AND distributes the app'
      def deploy()
        Dean::ConfigurationHelper.new.all_environments.each do |environment|
          Dean::Build.new.build_environment environment
          Dean::Upload.new.upload_environment environment
        end
      end
    end
  end
end
