module FormattedTime

	def self.check_time_token(token)
		return token if (token.length == 2)
		return "0" + token if (token.length == 1)
		return token[0..1]
	end


	def self.get(time)
		hr  = self.check_time_token(time.hour.to_s)
		min = self.check_time_token(time.min.to_s)
		sec = self.check_time_token(time.sec.to_s)

		return hr.to_s + ":" + min.to_s + ":" + sec.to_s
	end


	def self.compare(startTime, endTime)

		dif_secs = (endTime - startTime).to_i

		extract_token = -> (numSecsInUnit) {
			numUnits = (dif_secs / numSecsInUnit).to_i
			dif_secs -= (numUnits * numSecsInUnit)
			return self.check_time_token(numUnits.to_s)
		}

		hr  = extract_token.(3600)
		min = extract_token.(60)
		sec = self.check_time_token(dif_secs.to_s)

		verbose_string = -> {
			str = ""

			strip_token = -> (token) {
				return token[1] if (token.to_i < 10)
				return token
			}

			str += (strip_token.(hr) + " hours") if (hr.to_i > 0)

			if (min.to_i > 0)
				str += ", " if (str.length > 0)
				str += (strip_token.(min) + " minutes")
			end

			str += ", " if (str.length > 0)
			str += (strip_token.(sec) + " seconds")
			return str
		}

		return hr + ":" + min + ":" + sec + " (" + verbose_string.call.to_s + ")"
	end
end