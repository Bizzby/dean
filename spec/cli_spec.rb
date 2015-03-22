require 'spec_helper.rb'
require 'tempfile'

describe Dean::Cli do
  describe "bump_version VALUE" do
    before(:each) do
      @temp_plist = setup_plist('1.2.3', '4.5.6')

      Dean::ConfigurationHelper.stub(:all_environments) {
        { plist: @temp_plist }
      }
    end

    context "bump_version major" do
      let(:output) { capture(:stdout) { subject.bump('major') } }

      it "bumps the major version" do
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '2.2.3'
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '5.5.6'
      end
    end

    context "bump_version minor" do
      let(:output) { capture(:stdout) { subject.bump('minor') } }

      it "bumps the major version" do
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '1.3.3'
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '4.6.6'
      end
    end

    context "bump_version patch" do
      let(:output) { capture(:stdout) { subject.bump('patch') } }

      it "bumps the major version" do
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '1.2.4'
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '4.5.7'
      end
    end
  end
end
