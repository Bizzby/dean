module Dean
  class VersionBumper

    def bump(plist, value)
      version = Dean::ProjectVersionHelper.new.version_from_plist plist
      semver_helper = Dean::SemverHelper.new

      if value == :major
        new_version = semver_helper.bump_major version
        Dean::ProjectVersionHelper.new.set_version_in_plist new_version, plist
      end
    end
  end
end