class AddNewBanks < ActiveRecord::Migration
  def up
    data = [
      [23, 'JABA', '#a42991', 22, 1, 'jaba', 'ჯაბა კრედიტი', 'Jaba Credit'],
      [24, 'GIRO', '#7b973c', 23, 1, 'giro', 'გირო კრედიტი', 'Giro Credit'],
      [25, 'CRED', '#9ad187', 24, 1, 'cred', 'კრედიტორი', 'Creditor'],
      [26, 'INTE', '#ef372e', 25, 1, 'inte', 'ინტელიექსპრესი', 'Intel Express'],
      [27, 'FINC', '#004366', 26, 1, 'finc', 'ფინკრედიტი', 'Fincredit'],
      [28, 'MIBC', '#d21c23', 27, 1, 'mibc', 'მიკრო ბიზნეს კაპიტალი', 'Micro Business Capital'],
      [29, 'TBMC', '#d5b796', 28, 1, 'tbmc', 'თბილმიკროკრედიტი', 'Tbilmicrocredit'],
      [30, 'GOAC', '#3680d5', 29, 1, 'goac', 'გოა კრედიტი', 'Goa Credit']
    ]
    data.each{|d|
      b = Bank.create(
        id: d[0],
        code: d[1],
        buy_color: d[2],
        sell_color: d[2],
        order: d[3],
        org_type: d[4],
        name: d[6],
        image: d[5]
      )

      Globalize.with_locale(:en) do
        b.name = d[7]
        b.image = d[5]
      end
      b.save
    }
  end

  def down # old bank icon name is _ksb
    Bank.find(23).destroy
    Bank.find(24).destroy
    Bank.find(25).destroy
    Bank.find(26).destroy
    Bank.find(27).destroy
    Bank.find(28).destroy
    Bank.find(29).destroy
    Bank.find(30).destroy
  end
end
