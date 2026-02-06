class FixCreditCardForeignKey < ActiveRecord::Migration[8.1]
  def change
    # Remove the incorrect foreign key
    remove_foreign_key :transactions, column: :creditcard_id

    # Add the correct foreign key pointing to credit_cards table
    add_foreign_key :transactions, :credit_cards, column: :creditcard_id
  end
end
