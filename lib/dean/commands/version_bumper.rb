module Dean
  class VersionBumper

    def bump(plist, value)
      version = Dean::ProjectVersionHelper.new.version_from_plist plist
      semver_helper = Dean::SemverHelper.new

      new_version = version

      if value == :major
        new_version = semver_helper.bump_major version
      elsif value == :minor
        new_version = semver_helper.bump_minor version
      elsif value == :patch
        new_version = semver_helper.bump_patch version
      elsif value == :pre
        new_version = semver_helper.bump_pre version
      end

      Dean::ProjectVersionHelper.new.set_version_in_plist new_version, plist
    end
  end
end