FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com"}
    sequence(:name) {|n| "User #{n}"}
#    password "foobar"
#    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :board do
    height 10
    width 15
    sequence(:name) {|n| "Board #{n}"}
    timezone 'Eastern Time (US & Canada)'
    user
  end

  factory :tile do
    cost 1
    x_location 4
    y_location 5
    advertisement
    board
  end

  factory :advertisement do
    height 5
    width 5
    x_location 2
    y_location 3
    image 'FAKE IMAGE'
    user
    board
  end
end
