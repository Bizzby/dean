require "semantic"

module Dean
  class SemverHelper

    def bump_major version
      semver = semver version
      semver.major += 1
      semver.to_s
    end

    def bump_minor version
      semver = semver version
      semver.minor += 1
      semver.to_s
    end

    def bump_patch version
      semver = semver version
      semver.patch += 1
      semver.to_s
    end

    def bump_pre version
      semver = semver version 
      pre = semver.pre

      return if not pre

      split = pre.split('.')
      if split.length == 1
        semver.pre += '.1'
      else
        value = split[-1]
        split[-1] = (value.to_i + 1).to_s
        semver.pre = split.join '.'
      end

      semver.to_s
    end

    private

    def semver(string)
      Semantic::Version.new string
    end
  end
end