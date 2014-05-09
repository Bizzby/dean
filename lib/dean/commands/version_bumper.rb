module Dean
  class VersionBumper

    def bump_all_environments(value)
      configurations_helper = ConfigurationHelper.new
      configurations_helper.all_environments.each do |environment|
        bump_environment value, environment
      end
    end

    def bump_environment(value, environment)
      bump environment[:plist], value
    end

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

    def bump_short(plist, value)
      version = Dean::ProjectVersionHelper.new.short_version_from_plist plist
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

      Dean::ProjectVersionHelper.new.set_short_version_in_plist new_version, plist
    end

  end
end