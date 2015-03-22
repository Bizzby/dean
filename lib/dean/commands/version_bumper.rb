module Dean
  class VersionBumper

    def bump_all_environments(value, name=nil)
      configurations_helper = ConfigurationHelper.new
      # TODO: this is a dirty hack! please remove it soon!
      environments = configurations_helper.all_environments.uniq { |e| e[:plist] }
      environments.each do |environment|
        bump_environment value, environment, name
      end
    end

    def bump_environment(value, environment, name=nil)
      bump environment[:plist], value, name
      bump_short environment[:plist], value, name
    end

    def bump(plist, value, name=nil)
      version = XCBump::ProjectVersionHelper.new.version_from_plist plist
      semver_helper = XCBump::SemverHelper.new

      new_version = version

      if value == :major
        new_version = semver_helper.bump_major version
      elsif value == :minor
        new_version = semver_helper.bump_minor version
      elsif value == :patch
        new_version = semver_helper.bump_patch version
      elsif value == :pre
        new_version = semver_helper.bump_pre version, name
      end

      XCBump::ProjectVersionHelper.new.set_version_in_plist new_version, plist
    end

    def bump_short(plist, value, name=nil)
      version = XCBump::ProjectVersionHelper.new.short_version_from_plist plist
      semver_helper = XCBump::SemverHelper.new

      new_version = version

      if value == :major
        new_version = semver_helper.bump_major version
      elsif value == :minor
        new_version = semver_helper.bump_minor version
      elsif value == :patch
        new_version = semver_helper.bump_patch version
      elsif value == :pre
        new_version = semver_helper.bump_pre version, name
      end

      XCBump::ProjectVersionHelper.new.set_short_version_in_plist new_version, plist
    end

  end
end
