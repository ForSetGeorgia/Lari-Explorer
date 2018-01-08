class SetBanksOffState < ActiveRecord::Migration
  def up
    # 4 - Bank Republic - merged with tbc
    # 9 - Progress Bank - merged with tbc
    # 12 - Capital Bank - domain is off
    # 18 - Caucasus Development Bank Georgia - duplicates because exchange rate stopped changing
    Bank.where(id: [4, 9, 12, 18]).update_all(off: true)

  end

  def down
    Bank.where(id: [4, 9, 12, 18]).update_all(off: false)
  end
end
