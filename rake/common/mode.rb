module BuildMode

	def self.parse(input)

		lower = input.downcase

		if lower == "d" or lower == "deb"
			return "Debug"
		end

		if lower == "r" or lower == "rel"
			return "Release"
		end

		return input.capitalize
	end
end