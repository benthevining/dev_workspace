module FormattedTime

	def self.check_time_token(token)
		return "0" + token.to_s if (token.to_s.length == 1)
		return token
	end


	def self.get()
		timeNow = Time.now

		hr  = self.check_time_token(timeNow.hour.to_s)
		min = self.check_time_token(timeNow.min.to_s)
		sec = self.check_time_token(timeNow.sec.to_s)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end


	def self.compare(startString, endString)

		startTokens = startString.split(":")
		endTokens = endString.split(":")

		compare_tokens = -> (idx) { return endTokens[idx].to_i - startTokens[idx].to_i }

		hr  = self.check_time_token(compare_tokens.(0).to_s)
		min = self.check_time_token(compare_tokens.(1).to_s)
		sec = self.check_time_token(compare_tokens.(2).to_s)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end
end