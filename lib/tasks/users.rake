namespace :users do
  desc "Import users from file"
  task :import => :environment do
    require 'csv'
    
    while true do
      puts "File containing users to import:"
      filename = $stdin.gets.chomp
      if File.exists? filename
        break
      else
        puts "No such file."
      end
    end
    content = File.read(filename)
    
    i = 0
    CSV.foreach(filename, :headers => false, :col_sep => "\t") do |row|
      names = row.first.rpartition(" ")
      user = User.new({ first_name: names.first, last_name: names.last, email: (row.last || "").downcase }, as: :admin)
      user.reset_password
      i = i+1 if user.save(validate: false)
    end
    
    puts "Finished! Imported #{i} users. #{User.count}"
  end
  
  desc "Send activation mails to all users"
  task :send_activation_mails => :environment do
    User.all.each do |user|
      UserMailer.activation(user).deliver
    end
    puts "Finished!"
  end
end