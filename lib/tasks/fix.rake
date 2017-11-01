# scraper.rake
# encoding: UTF-8

require 'csv'
#require 'open-uri'
# require 'nokogiri'
# require 'mechanize'

class Procredit
  @currencies = []

  def self.is_number? string
    true if Float(string) rescue false
  end

  def self.check_rates(currency, buy, sell)
    return currency.length == 3 && !@currencies.index(currency).nil? && is_number?(buy) && is_number?(sell) && buy.to_f != 0 && sell.to_f != 0
  end


  def self.fix!
    puts "Procredit data loader"
    @currencies = Currency.pluck(:code)
    file = "#{Rails.root}/datafiles/procredit/procredit_2004-2017.10.31.csv"
    CSV.foreach(file, :headers => false) do |row|
      code = row[4]
      date = Date.parse row[3]
      buy = row[1].to_f
      sell = row[2].to_f

      if check_rates(code, buy, sell)
        Rate.create_or_update(date, code, nil, buy, sell, 6)
      else
        puts "#{i} - error"
      end
    end
  end
end


namespace :fix do
  # copied by hand from site table, formated to be inserted
  # into table like INSERT INTO `tmp`(`code`, `date`, `buy`, `sell` ) VALUES ('USD', STR_TO_DATE('31-10-2017 06:43 PM', '%d-%m-%Y %h:%i %p'), '2.5900', '2.6400'),
    #   CREATE TABLE `tmp` (
    #  `id` int(11) NOT NULL AUTO_INCREMENT,
    #  `buy` float NOT NULL,
    #  `sell` float NOT NULL,
    #  `date` datetime NOT NULL,
    #  `code` varchar(255) NOT NULL,
    #  PRIMARY KEY (`id`)
    # ) ENGINE=InnoDB AUTO_INCREMENT=3781 DEFAULT CHARSET=utf8
  # exported to csv for read
  desc "Procredit uploader"
  task :procredit => :environment do
    Procredit.fix!
  end
end
