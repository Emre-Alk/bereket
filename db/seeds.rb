
puts "destroying..."

User.destroy_all
AssoType.destroy_all
Asso.destroy_all
Donator.destroy_all
PlaceType.destroy_all
Place.destroy_all
Donation.destroy_all

puts "start seeding..."
puts "creating users..."
user_asso = User.create!(email: "asso@asso.com", password: '123456', role: 'asso')
user_donator = User.create!(email: "donator@donator.com", password: '123456', role: 'donator')

puts "creating asso_type..."
AssoType.create!(name: "organismes d'intérêt général ou reconnu d'utilité publique établis en France")

puts "creating asso and donator..."
asso = Asso.create!(name: 'assotest', code_nra: 'W123456789', email: user_asso.email, user: user_asso, asso_type_id: 1)
donator = Donator.create!(first_name: 'FNtest', last_name: 'LNtest', email: user_donator.email, user: user_donator)

puts "creating place_type..."
PlaceType.create!(name: 'Mosquée')

puts "creating place..."
place = Place.create!(name: 'malik', address: 'test', street_no: 'test', city: 'test', country: 'test', asso: , place_type_id: 1)

puts "creating donations ..."
date = [1.day.from_now, 2.days.from_now, 3.days.from_now, 4.days.from_now, Date.today]
5.times do
  money = rand(10..30)
  datepicker = date.sample
  index = date.index(datepicker)
  Donation.create!(donator: , place: , amount: money, occured_on: datepicker)
  date.delete_at(index)
end

puts "seeding done"
