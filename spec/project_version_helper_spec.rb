require "spec_helper"
require "tempfile"

describe XCBump::ProjectVersionHelper do
  let (:helper) { described_class.new }

  context "when the plist exists on disk" do
    before do
      @expected_version = '4.2.0'
      @expected_short_version = '42'
      @temp_plist = Tempfile.new 'plist'
      @plist = {
        'CFBundleVersion' => @expected_version,
        'CFBundleShortVersionString' => @expected_short_version
      }
      # I don't like using plist gem in here, need more context independency
      Plist::Emit::save_plist @plist, @temp_plist.path
    end

    it "should return the CFBundleVersion value" do
      expect(helper.version_from_plist @temp_plist.path).to eq @expected_version
    end

    it "should set the CFBundleVersion value to the given one" do
      expected_version = '1.2.3'
      helper.set_version_in_plist expected_version, @temp_plist.path

      version = Plist::parse_xml(@temp_plist.path)['CFBundleVersion']

      expect(version).to eq expected_version
    end

    it "should return the CFBundleShortVersionString value" do
      expect(helper.short_version_from_plist @temp_plist.path).to eq @expected_short_version
    end

    it "should set the CFBundleShortVersionString value to the given one" do
      expected_version = '23'
      helper.set_short_version_in_plist expected_version, @temp_plist.path

      version = Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']

      expect(version).to eq expected_version
    end
  end

  context "when the plist does not exists on disk" do
    before do
      File.stub(:exists?).and_return false
    end

    it "should return a -1 version value" do
      expect(helper.version_from_plist 'plist').to eq -1
    end

    it "should return a -1 short version value" do
      expect(helper.version_from_plist 'plist').to eq -1
    end
  end

  def local_file(name)
    "#{Dir.pwd}/#{name}"
  end
end
