module Screen
    class Screen
        def self.clear
            print "\e[2J\e[f"
        end
    end
end