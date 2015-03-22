module XCBump
  class GitHelper

    def commit_asking_user(prompt, new_version, envs_paths)
      def ask_user(message)
        puts message.chomp + " (y/n)"
        user_input = $stdin.gets.chomp!
        user_input == 'y'
      end

      if ask_user prompt
        # unstage everything for safety
        system "git reset HEAD . 1> /dev/null"
        # stage the info plists
        envs_paths.each do |path|
          system "git add #{path}"
        end
        # commit
        message = "Bumped version to #{new_version}"
        system "git commit -m 'Bumped version to #{new_version}' 1> /dev/null"

        if ask_user "Do you want to tag this commit with version #{new_version}? (Editor will open to insert message)"
          system "git tag -a #{new_version}"
        end

        puts "Done"
      else
        puts "Changes not committed"
      end
    end
  end
end
