require "spec_helper"

describe Dean::SemverHelper do
  let (:helper) { described_class.new }

  it "shuold bump the major value of the given version" do
    expect(helper.bump_major '1.0.0').to eq '2.0.0'
  end

  it "shuold bump the minor value of the given version" do
    expect(helper.bump_minor '1.0.0').to eq '1.1.0'
  end

  it "shuold bump the patch value of the given version" do
    expect(helper.bump_patch '1.0.0').to eq '1.0.1'
  end

  it "shuold bump the pre value of the given version" do
    expect(helper.bump_pre '1.0.0-pre.0').to eq '1.0.0-pre.1'
  end
  
  it "shuold bump the pre value of the given version to 1 if no number is present" do
    expect(helper.bump_pre '1.0.0-pre').to eq '1.0.0-pre.1'
  end

  context "when bumping a version with a pre value" do
    it "shold remove the pre value if bumping the major value" do
      expect(helper.bump_major '1.0.0-pre.0').to eq '2.0.0'
    end

    it "shold remove the pre value if bumping the minor value" do
      expect(helper.bump_minor '1.0.0-pre.0').to eq '1.1.0'
    end

    it "shold remove the pre value if bumping the patch value" do
      expect(helper.bump_patch '1.0.0-pre').to eq '1.0.1'
    end
  end
end