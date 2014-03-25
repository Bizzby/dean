require 'aws-sdk'

module Dean
  class Upload

    def upload_all_environments
      ConfigurationHelper.new().all_environments.each do |environment|
        upload_environmet environment
      end
    end

    def upload_environmet(environment)
      configurations = ConfigurationHelper.new().s3_settings_for_environment environment
      
      s3 = AWS::S3.new
      bucket = s3.buckets[configurations[:bucket_name]]

      version = ProjectVersionHelper.new.version_from_plist environment[:plist]

      s3_location = "#{configurations[:bucket_location]}/v#{version}/app.ipa"

      ipa_on_s3 = bucket.objects[s3_location]
      if ipa_on_s3.exists?
        puts "The file already exists on the bucket!"
      else
        #
        # TODO this shouldn't be static, but I need more time to think about how to structure it
        #
        build_settings = ConfigurationHelper.new().build_settings_for_environment environment
        disk_location = "#{Dir.pwd}/#{build_settings[:location]}/#{version}/Bizzby.ipa"

        puts "Uploading .ipa to #{s3_location}"
        ipa_on_s3.write( :file => disk_location)
        puts "Uploaded :)"
      end
    end
  end
end