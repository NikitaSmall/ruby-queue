FactoryGirl.define do
  factory :task do
    handler 'summ'
    argument '{"a":10,"b":12}'
  end
end
