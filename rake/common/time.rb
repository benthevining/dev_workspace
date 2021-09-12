module FormattedTime

	def self.get()
		timeNow = Time.now
		return timeNow.hour.to_s + ":" + timeNow.min.to_s + ":" + timeNow.sec.to_s
	end


	def self.compare(startString, endString)

		startTokens = startString.split(":")
		endTokens = endString.split(":")

		hr = endTokens[0].to_i - startTokens[0].to_i 
		min = endTokens[1].to_i - startTokens[1].to_i
		sec = endTokens[2].to_i - startTokens[2].to_i

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end
end