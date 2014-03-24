require 'thor'

module Dean
  module Cli
    class Application < Thor

      desc 'build', 'Builds the ipa'
      def build()
        puts "Imma build your app"
      end

      desc 'distribute', 'Distribute the app. (Now only uploads the ipa to the S3 server)'
      def distribute()
        puts "Imma upload your app"
      end

      desc 'deploy', 'Deploy the app. Builds AND distributes the app'
      def deploy()
        puts "Imma build AND upload your app"
      end
    end
  end
end
