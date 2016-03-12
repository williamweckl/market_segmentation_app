require 'faker'

50.times do |n|
  Position.find_or_create_by!(name: Faker::Company.profession)
end

100.times do |n|
  name = Faker::Name.name
  contact = Contact.create(name: name, email: Faker::Internet.email(name), state: State.list.sample, age: (17..80).to_a.sample, position: Position.all.sample)
end