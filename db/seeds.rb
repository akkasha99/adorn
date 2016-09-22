# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Deleting existing roles..."
roles = Role.all
roles.each { |role| role.destroy } if roles.present?

puts "Adding default roles"
%w(admin user).each do |name|
  Role.create(:title => name)
end

puts "Deleting existing users..."
users = User.all
users.each { |user| user.destroy } if users.present?

#user = User.where(:email => "admin@adoorn.com")
#user.destroy  if user.present?
# add admin

puts "adding Adoorn Admin"
role = Role.where(:title => "admin").first
user = User.new(:email => "admin@adoorn.com", :user_name => 'admin', :first_name => 'Admin', :password => "adoorn2014")
user.skip_confirmation!
user.save!
user.role = role
