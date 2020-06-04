5.times do |n|
  group = Group.create!(
    name: "テストグループ#{n}",
    description: "テストのグループです"
  )
  UserGroup.create!(
    user_id: 7,
    group_id: group.id
  )
end
