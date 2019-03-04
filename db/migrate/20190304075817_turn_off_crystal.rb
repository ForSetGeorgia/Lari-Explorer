class TurnOffCrystal < ActiveRecord::Migration
  def up
    # 20 - Bonaco
    Bank.where(id: 20).update_all(off: true)

  end

  def down
    Bank.where(id: 20).update_all(off: false)
  end
end
