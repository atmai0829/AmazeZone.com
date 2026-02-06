class CreditCard < ApplicationRecord
  belongs_to :user
  has_many :transactions, foreign_key: 'creditcard_id'
end
