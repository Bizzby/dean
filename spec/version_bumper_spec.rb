require "spec_helper"
require "tempfile"

describe Dean::VersionBumper do
  let (:bumper) { described_class.new }

  describe "#bump" do
    it "should have two mandatory parameter" do
      expect{ bumper.bump }.to raise_error(ArgumentError)
      expect{ bumper.bump "something" }.to raise_error(ArgumentError)
    end

    it "should bump the major value of the given version when passed the :major parameter" do
        temp_plist = Tempfile.new 'plist'
        plist = {
          'CFBundleVersion' => '0.0.0',
          'CFBundleShortVersionString' => '4'
        }
        # I don't like using plist gem in here, need more context independency
        Plist::Emit::save_plist plist, temp_plist.path

        bumper.bump temp_plist.path, :major

        expect(Plist::parse_xml(temp_plist.path)['CFBundleVersion']).to eq '1.0.0'

        temp_plist.unlink
    end
  end
end