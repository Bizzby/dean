require 'aws-sdk'

module Dean
  class Upload

    def upload_all_environments
      ConfigurationHelper.new().all_environments.each do |environment|
        upload_environment environment
      end
    end

    def upload_environment(environment)
      configurations = ConfigurationHelper.new().s3_settings_for_environment environment
      
      s3 = AWS::S3.new
      bucket = s3.buckets[configurations[:bucket_name]]

      version = ProjectVersionHelper.new.version_from_plist environment[:plist]

      s3_location = "#{configurations[:bucket_location]}/v#{version}/app.ipa"

      ipa_on_s3 = bucket.objects[s3_location]
      if ipa_on_s3.exists?
        puts "The file already exists on the bucket!"
      else
        build_settings = ConfigurationHelper.new().build_settings_for_environment environment
        # TODO: We are assuming the project name be the .ipa name. This is not safe
        project_name = build_settings[:project]
        app_name = File.basename(project_name, File.extname(project_name))
        disk_location = "#{Dir.pwd}/#{build_settings[:location]}/#{version}/#{app_name}.ipa"

        puts "Uploading .ipa to #{s3_location}"
        ipa_on_s3.write( :file => disk_location)
        puts "Uploaded :)"
      end
    end
  end
end