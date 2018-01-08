class AddOffToBanks < ActiveRecord::Migration
  def change
    add_column :banks, :off, :boolean, default: false
  end
end
