require 'spec_helper.rb'
require 'tempfile'
require 'yaml'

def stub_dean_yml(plist_path)
  @deanfile = File.new(Dir.pwd + '/.dean.yml', 'w')
  config = {
    environments: [
      {
        plist: plist_path
      }
    ]
  }
  @deanfile.write(config.to_yaml)
  @deanfile.close
end

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def capture_stderr(&block)
  original_stderr = $stderr
  $stderr = fake = StringIO.new
  begin
    yield
  ensure
    $stderr = original_stderr
  end
  fake.string
end

describe Dean::Cli::Application do
  describe "bump_version VALUE" do
    before(:each) do
      @temp_plist = setup_plist('1.2.3', '4.5.6')
      stub_dean_yml(@temp_plist.path)
    end

    after(:each) do
      File.delete(@deanfile.path)
    end

    context "bump_version major" do
      it "bumps the major version" do
        subject.bump('major')
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '2.0.0'
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '5.0.0'
      end
    end

    context "bump_version minor" do
      it "bumps the major version" do
        subject.bump('minor')
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '1.3.0'
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '4.6.0'
      end
    end

    context "bump_version patch" do
      it "bumps the major version" do
        subject.bump('patch')
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleVersion']).to eq '1.2.4'
        expect(Plist::parse_xml(@temp_plist.path)['CFBundleShortVersionString']).to eq '4.5.7'
      end
    end
  end
end
