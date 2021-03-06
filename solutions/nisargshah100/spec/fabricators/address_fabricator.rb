# == Schema Information
#
# Table name: addresses
#
#  id         :integer         not null, primary key
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

Fabricator(:address) do
  street "1355 Jonan Street"
  city "Jonanville"
  state "JO"
  zipcode "00010"
end
