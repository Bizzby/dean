
module Dean
  class ProjectVersionHelper

    def version_from_plist(plist)
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
      version = plist["CFBundleVersion"]
    end

    def set_version_in_plist(version, plist_path)
      if not File.exists? plist_path
        puts "Cannot open #{plist_path}. File not found"
        return
      end

      plist = Plist::parse_xml plist_path
      plist["CFBundleVersion"] = version
      plist.save_plist plist_path
    end
  end
end