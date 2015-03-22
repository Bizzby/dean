require 'rspec'
require 'dean'
require 'xcbump'

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
