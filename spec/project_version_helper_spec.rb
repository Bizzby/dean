require "spec_helper"

describe Dean::ProjectVersionHelper do
  describe "#version_from_plist" do
    let (:helper) { described_class.new }

    context "when the plist exists on disk" do
      before do
        @expected_version = '4.2.0' 
        File.stub(:exists?).and_return true
        # I don't like stubbing this gem. It's not really a black box approach
        Plist.stub(:parse_xml).and_return({ 
          'CFBundleVersion' => @expected_version, 
          'CFBundleShortVersionString' => '4' 
          })
      end

      it "should return the CFBundleVersion value" do
        expect(helper.version_from_plist 'plist').to eq @expected_version
      end
    end

    context "when the plist does not exists on disk" do
      before do
        File.stub(:exists?).and_return false
      end

      it "should return -1" do
        expect(helper.version_from_plist 'plist').to eq -1
      end
    end
  end

  def local_file(name)
    "#{Dir.pwd}/#{name}"
  end
end
