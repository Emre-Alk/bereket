
puts "destroying..."

# User.destroy_all
# AssoType.destroy_all
# Asso.destroy_all
# Donator.destroy_all
# PlaceType.destroy_all
# Place.destroy_all
# Donation.destroy_all
Donation.destroy_all
Place.destroy_all
PlaceType.destroy_all
Asso.destroy_all
AssoType.destroy_all
Donator.destroy_all
User.destroy_all



puts "start seeding..."
puts "creating users..."
user_asso = User.create!(
  email: "asso@asso.com",
  password: '123456',
  first_name: 'MonAsso',
  last_name: 'MonAsso',
  role: 'asso'
)
user_donator = User.create!(
  email: "donator@donator.com",
  password: '123456',
  first_name: 'FNtest',
  last_name: 'LNtest',
  role: 'donator'
)

puts "creating asso_type..."
asso_type = AssoType.create!(name: "organismes d'intérêt général ou reconnu d'utilité publique établis en France")

puts "creating asso and donator..."
asso = Asso.create!(
  name: 'assotest',
  code_nra: 'W123456789',
  email: user_asso.email,
  user: user_asso,
  asso_type_id: asso_type.id
)
# donator is auto created if at registration user chose role as donator
# donator = Donator.create!(
#   first_name: 'FNtest',
#   last_name: 'LNtest',
#   email: user_donator.email,
#   user: user_donator
# )
donator = Donator.first

puts "creating place_type..."
mosque = PlaceType.create!(name: 'Mosquée')
eglise = PlaceType.create!(name: 'Eglise')

puts "creating place..."

place = Place.create!(
  name: 'test',
  address: 'test',
  street_no: 'test',
  zip_code: '69000',
  city: 'test',
  country: 'test',
  asso:,
  place_type_id: eglise.id
)
if Rails.env.production?
  qr_code = "https://appmynewproject-8b21a82c26ce.herokuapp.com/places/#{place.id}/donations/new"
else
  qr_code = "http://192.168.1.168:3000/places/#{place.id}/donations/new"
end
place.update!(qr_code:)

puts "creating donations ..."
date = [1.day.ago, 2.days.ago, 3.days.ago, 4.days.ago, Date.today]
5.times do
  money = rand(10..30) * 100
  datepicker = date.sample
  index = date.index(datepicker)
  Donation.create!(
    donator:,
    place:,
    amount: money,
    occured_on: datepicker
  )
  date.delete_at(index)
end

puts "seeding done"
