require "spec_helper"

describe Dean::Build do
  let (:builder) { described_class.new }

  context "when building an environment with a missing plist file" do
    it "should raise an IOError" do
      invalid_plist_path = 'invalid.plist'
      environment = {
        :name => 'environment',
        :plist => invalid_plist_path,
        :build_settings => {
          :workspace => 'MyProject.xcworkspace',
          :project => 'MyProject.xcodeproj',
          :build_configuration => 'Beta',
          :scheme => 'MyProject-Beta',
          :provisioning_profile => 'MyProject_Stage_Enterprise_Provisioning_Profile.mobileprovision',
          :location => 'Builds/Beta',
        }
      }

      File.stub(:exists?) { true } # default stub value
      File.stub(:exists?).with(/#{invalid_plist_path}/) { false }

      expect{ builder.build_environment environment }.to raise_error(IOError)
    end
  end

  context "when building an environment with a missing provisioning profile file" do
    it "should raise an IOError" do
      invalid_provisioning_profile_path = 'invalid.mobileprovision'
      environment = {
        :name => 'environment',
        :plist => 'MyProject-Info.plist',
        :build_settings => {
          :workspace => 'MyProject.xcworkspace',
          :project => 'MyProject.xcodeproj',
          :build_configuration => 'Beta',
          :scheme => 'MyProject-Beta',
          :provisioning_profile => invalid_provisioning_profile_path,
          :location => 'Builds/Beta',
        }
      }

      File.stub(:exists?) { true } # default stub value
      File.stub(:exists?).with(/#{invalid_provisioning_profile_path}/) { false }

      expect{ builder.build_environment environment }.to raise_error(IOError)
    end
  end
end
