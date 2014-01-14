# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create!(email: 'demo@lta.io', password: 'qweasd42',
  password_confirmation: 'qweasd42', role_cd: 2)
user.confirm!

lta = User.create!(email: 'contact@lta.io', password: 'qweasd42',
  password_confirmation: 'qweasd42', role_cd: 2)
lta.confirm!
