require "spec_helper"
require "tempfile"

describe Dean::VersionBumper do
  let (:bumper) { described_class.new }

  context "bumping an environment" do
    before(:each) do
      Dean::ProjectVersionHelper.stub(:version_from_plist) { "1.0.0" }
      Dean::ProjectVersionHelper.any_instance.stub(:set_version_in_plist)
      Dean::ProjectVersionHelper.stub(:short_version_from_plist) { "1.0.0" }
      Dean::ProjectVersionHelper.any_instance.stub(:set_short_version_in_plist)
    end

    it "should bump the version" do
      bumper.should_receive :bump
      bumper.bump_environment "major", { :plist => "path" }
    end

    it "should bump the short version" do
      bumper.should_receive :bump_short
      bumper.bump_environment "major", { :plist => "path" }
    end
  end

  context "bumping the version value of a plist file" do
    before(:each) do
      @temp_plist = setup_plist
    end

    it "should have two mandatory parameter" do
      expect{ bumper.bump }.to raise_error(ArgumentError)
      expect{ bumper.bump "something" }.to raise_error(ArgumentError)
    end

    it "should bump the major value of the given version when passed the :major parameter" do
      bumper.bump @temp_plist.path, :major
      expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '1.0.0'
    end

    it "should bump the minor value of the given version when passed the :minor parameter" do
      bumper.bump @temp_plist.path, :minor
      expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '0.1.0'
    end

    it "should bump the patch value of the given version when passed the :patch parameter" do
      bumper.bump @temp_plist.path, :patch
      expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '0.0.1'
    end

    it "should bump the pre value of the given version when passed the :pre parameter" do
      tempfile = setup_plist '0.0.0-pre.0'
      bumper.bump tempfile.path, :pre
      expect(Plist::parse_xml(tempfile.path)['CFBundleVersion']).to eq '0.0.0-pre.1'
    end
  end

  context "bumping the short version value of a plist file" do
    before(:each) do
      @temp_plist = setup_plist
    end

    it "should have two mandatory parameter" do
      expect{ bumper.bump_short }.to raise_error(ArgumentError)
      expect{ bumper.bump_short "something" }.to raise_error(ArgumentError)
    end

    it "should bump the major value of the given version when passed the :major parameter" do
      bumper.bump_short @temp_plist.path, :major
      expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '1.0.0'
    end

    it "should bump the minor value of the given version when passed the :minor parameter" do
      bumper.bump_short @temp_plist.path, :minor
      expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '0.1.0'
    end

    it "should bump the patch value of the given version when passed the :patch parameter" do
      bumper.bump_short @temp_plist.path, :patch
      expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '0.0.1'
    end

    it "should bump the pre value of the given version when passed the :pre parameter" do
      tempfile = setup_plist '0.0.0', '0.0.0-pre.0'
      bumper.bump_short tempfile.path, :pre
      expect(Plist::parse_xml(tempfile.path)['CFBundleShortVersionString']).to eq '0.0.0-pre.1'

    end
  end

  def setup_plist(version='0.0.0', version_short='0.0.0')
    tempfile = Tempfile.new 'plist'
    plist = {
      'CFBundleVersion' => version,
      'CFBundleShortVersionString' => version_short
    }
    # I don't like using plist gem in here, need more context independency
    Plist::Emit::save_plist plist, tempfile.path
    return tempfile
  end
end