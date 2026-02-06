class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :credit_card, foreign_key: 'creditcard_id'
end
