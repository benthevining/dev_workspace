module FormattedTime

	def self.check_time_token(token)
		return "0" + token.to_s if (token.to_s.length == 1)
		return token
	end


	def self.get()
		timeNow = Time.now

		hr  = timeNow.hour.to_s; hr = self.check_time_token(hr)
		min = timeNow.min.to_s; min = self.check_time_token(min)
		sec = timeNow.sec.to_s; sec = self.check_time_token(sec)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end


	def self.compare(startString, endString)

		startTokens = startString.split(":")
		endTokens = endString.split(":")

		hr  = (endTokens[0].to_i - startTokens[0].to_i).to_s; hr  = self.check_time_token(hr)
		min = (endTokens[1].to_i - startTokens[1].to_i).to_s; min = self.check_time_token(min)
		sec = (endTokens[2].to_i - startTokens[2].to_i).to_s; sec = self.check_time_token(sec)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end
end