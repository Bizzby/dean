module XCBump
  class ProjectVersionHelper

    def version_from_plist(plist)
      value_from_plist('CFBundleVersion', plist)
    end

    def set_version_in_plist(version, plist_path)
      set_value_in_plist("CFBundleVersion", version, plist_path)
    end

    def short_version_from_plist(plist)
      value_from_plist('CFBundleShortVersionString', plist)
    end

    def set_short_version_in_plist(version, plist_path)
      set_value_in_plist("CFBundleShortVersionString", version, plist_path)
    end

    private

    def value_from_plist(key, plist)
      plist_path = ''
      if plist[0] == '/'
        plist_path = plist
      else
        plist_path = "#{Dir.pwd}/#{plist}"
      end

      if not File.exists? plist_path
        # Maybe raise exception instead?
        return -1
      end

      plist = Plist::parse_xml plist_path
      return plist[key]
    end

    def set_value_in_plist(key, value, plist_path)
      if not File.exists? plist_path
        puts "Cannot open #{plist_path}. File not found"
        return
      end

      plist = Plist::parse_xml plist_path
      plist[key] = value
      plist.save_plist plist_path
    end
  end
end
