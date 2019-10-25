FactoryGirl.define do
  factory :user, class: 'User' do
    email 'random@gmail.com'
    password 'random123'
    password_confirmation 'random123'
  end
end