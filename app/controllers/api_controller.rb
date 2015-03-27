class ApiController < ApplicationController

  def nbg
    params[:currency] ||= 'USD'

    rates = []

    @currencies = Currency.data
    params[:currency].split(',').each{|x|
      if CURRENCIES.index(x) != nil
        cur = @currencies.select{|c| c[0] == x }.first
         Rails.logger.debug("--------------------------------------------#{cur[1]} #{I18n.locale}")
        x = Rate.utc_and_rates(x)
        if x.present?
          rates << {code: cur[0], name: cur[0] + ' - ' + cur[1], ratio: cur[2], data: x}
        end
      end      
    }
    respond_to do |format|
      format.json { render json: { :title => I18n.t('chart.nbg.title') , :rates => rates } }
    end
  end
  def rates
    currency = params[:currency]
    bank = BANKS & params[:bank].split(',')
    dt = []
    #cur = Currency.find_by_code(currency)

    if CURRENCIES.index(currency) != nil && bank.any?
      bank.each{|bid|
        b = Bank.find_by_id(bid)            
          if b.id == 1 
            x = Rate.rates_nbg(currency, bid)
            if x.present?
              dt << { id: "b_" + b.id.to_s, name:  (b.name + " (" + b.code + ")"), data: x, color: b.buy_color }
            end
          else
            x = Rate.rates_buy(currency, bid)
            if x.present?
              dt << { id: "b_buy_" + b.id.to_s, name: (b.name + " " +  t('app.common.buy') + " (" + b.code + ")"), data: x, color: b.buy_color, dashStyle: 'shortdot' }
            end
            x = Rate.rates_sell(currency, bid)
            if x.present?
              dt << { id: "b_sell_" + b.id.to_s, name:  (b.name + " " +  t('app.common.sell') +  " (" + b.code + ")"), data: x, color: b.sell_color, dashStyle: 'shortdash' }
            end
          end
        
      }
    end
    respond_to do |format|
      format.json { render json: { rates: dt } }
    end
  end
  def calculator
    amount = params[:amount].to_f
    cur = params[:cur]
    dir = params[:dir]     

    errors = []
    #n = Time.now

    begin  
      date_from = params[:date_from].to_i 
      if date_from > 0
        date_from = Time.at(date_from/1000.0)
      else
        raise
      end  
    rescue  
      errors.push({ field: 'date_from', message: 'From date field is invalid.' })
    end  

    begin  
      date_to = params[:date_to].to_i 
      if date_to > 0
        date_to = Time.at(date_to/1000.0)
      else
        raise
      end  
    rescue  
      errors.push({ field: 'date_to', message: 'To date field is invalid.' })
    end  

     data = { amount: amount, cur: cur, dir: dir, date_from: date_from, date_to: date_to, valid: true }
     errors.push({ field: 'amount', message: 'Amount should be greater than 0.' }) if(amount <= 0)
     errors.push({ field: 'cur', message: 'Currency field is not valid.' }) if(CURRENCIES.index(cur) == nil)
     errors.push({ field: 'dir', message: 'Converting direction field can be 0 or 1, 1 means GEL -> USD, 0: USD -> GEL.' }) if(dir == 0 || dir == 1)



    if(errors.any?)
      data['errors'] = errors
      data['valid'] = false
    else
      result = { }
      rates = Rate.nbg_rates(cur, date_from, date_to)
      # get rates for period
      # get first and last row
      # process dir field
      # calculate result based on amount
      #return result
      result['rates'] = rates
      data['result'] = result
    end



    respond_to do |format|
      format.json { render json: data }
    end
  end
end
