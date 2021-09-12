module FormattedTime

	def self.get()
		timeNow = Time.now

		hr  = timeNow.hour.to_s; hr = "0" + hr  if (hr.length == 1)
		min = timeNow.min.to_s; min = "0" + min if (min.length == 1)
		sec = timeNow.sec.to_s; sec = "0" + sec if (sec.length == 1)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end


	def self.compare(startString, endString)

		startTokens = startString.split(":")
		endTokens = endString.split(":")

		hr  = (endTokens[0].to_i - startTokens[0].to_i).to_s; hr  = "0" + hr  if (hr.length == 1)
		min = (endTokens[1].to_i - startTokens[1].to_i).to_s; min = "0" + min if (min.length == 1)
		sec = (endTokens[2].to_i - startTokens[2].to_i).to_s; sec = "0" + sec if (sec.length == 1)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end
end