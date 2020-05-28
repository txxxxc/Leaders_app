5.times do |n|
  puts n
  User.create!(
    name: "メンバー#{n + 1}",
    email: "member#{n + 1}@test.com",
    password: "test",
    role: "member"
  )
end

User.create!(
  name: 'メンター',
  email: 'mentor@test.com',
  password: 'test',
  role: 'mentor'
)

Group.create!(
  name: 'テストグループ',
  description: 'テストのグループです'
)

5.times do |n|
  Contribution.create!(
    body: "テストの投稿#{n + 1}",
    status: "new",
    priority: "important",
    user_id: n + 1,
    group_id: 1
  )
end

5.times do |n|
  UserGroup.create!(
    user_id: n + 1,
    group_id: 1
  )
end


