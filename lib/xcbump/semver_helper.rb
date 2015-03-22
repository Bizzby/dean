require "semantic"

module XCBump
  class SemverHelper

    def bump_major version
      semver = no_pre_semver version
      semver.major += 1
      semver.minor = 0
      semver.patch = 0
      semver.pre = nil
      semver.to_s
    end

    def bump_minor version
      semver = no_pre_semver version
      semver.minor += 1
      semver.patch = 0
      semver.pre = nil
      semver.to_s
    end

    def bump_patch version
      semver = no_pre_semver version
      semver.patch += 1
      semver.to_s
    end

    def bump_pre version, name=nil
      semver = semver version 
      pre = semver.pre

      if not pre
        pre_name = name ? name : "pre"
        semver.pre = pre_name + ".1"
        return semver.to_s
      end

      split = pre.split('.')
      if split.length == 1
        if name
          semver.pre = name
        end
        semver.pre += '.1'
      else
        if name
          split[0] = name
        end
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

    def no_pre_semver(string)
      v = semver string
      if v.pre
        v.pre = nil
      end
      return v
    end
  end
end
