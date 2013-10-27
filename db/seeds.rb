10.times do |i|
	attrs = { password: "123456" }
	if i == 1
		attrs.merge!({ first_name: "Albrecht", last_name: "Oster", email: "a.oster@online.de", admin: true })
	else
		attrs.merge!({ first_name: Faker::NameDE.first_name, last_name: Faker::NameDE.last_name, email: Faker::Internet.free_email })
	end
	user = User.new(attrs, without_protection: true)
	user.save(perform_validations: false)
end