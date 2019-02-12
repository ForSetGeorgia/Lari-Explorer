class TurnOffBonaco < ActiveRecord::Migration
  def up
    # 21 - Bonaco
    Bank.where(id: 21).update_all(off: true)

  end

  def down
    Bank.where(id: 21).update_all(off: false)
  end
end
