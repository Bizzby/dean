
module Dean
  class ProjectVersionHelper

    def version_from_plist(plist)
      plist_path = "#{Dir.pwd}/#{plist}"

      if not File.exists? plist_path
        puts "Cannot open #{plist_path}. File not found"
        return
      end

      plist = Plist::parse_xml plist_path
      version = plist["CFBundleVersion"]
    end
  end
end