module FormattedTime

	def self.check_time_token(token)
		return token if (token.length == 2)
		return "0" + token if (token.length == 1)
		return token[0..1]
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
				return token.to_i < 10 ? token[1] : token
			}

			make_plural_if_needed = -> (num) {
				str += "s" if num.to_i > 1
			}

			if (hr.to_i > 0)
				str += (strip_token.(hr) + " hour")
				make_plural_if_needed.(hr)
			end

			add_comma_if_needed = -> {
				str += ", " if (str.length > 0)
			}

			if (min.to_i > 0)
				add_comma_if_needed.call
				str += (strip_token.(min) + " minute")
				make_plural_if_needed.(min)
			end

			add_comma_if_needed.call
			str += (strip_token.(sec) + " second")
			make_plural_if_needed.(sec)

			return str
		}

		return hr + ":" + min + ":" + sec + " (" + verbose_string.call.to_s + ")"
	end
end