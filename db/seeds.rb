# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


@user = User.find_or_create_by(email: 'admin@mail.io')
@user.password = 'password'
@user.save

10.times do |i|
  @user = User.find_or_create_by(email: "user#{i}@mail.io")
  @user.password = 'password'
  @user.save
end

User.all.each do |user|
  room = user.rooms.build(name: "PublicRoom-#{user.id}")
  room.users_rooms.build(user_id: user.id, status: :accepted, role: :owner)
  room.save
end
