require "json"


file = open("products.json")
json = JSON.parse(file.read)


namespace :build do

	json["product"].each do |product|

	end
end