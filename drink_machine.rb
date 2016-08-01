class DrinkMachine
  DRINKS_WITH_PRICES = {
    cola: 335,
    nestea: 420,
    rich: 375,
    bonaqua: 265,
    burn: 415,
  }

  COINS = [100, 50, 25, 10, 5]

  def initialize(coins_count = 100)
    @remaining_coins = COINS.map { |c| [c, coins_count] }.to_h
  end

  def buy(**options)
    begin
      @drink_price = get_drink_price options[:item]
      amount = get_amount options[:amount]

      check_remaining_coins

      change = amount - @drink_price
      return "Not enough many, #{options[:item]} cost $#{@drink_price.to_f / 100}" if  change < 0

      result = []
      COINS.map do |c|
        next unless change - c >= 0

        change -= c
        result << c

        @remaining_coins[c] -= 1

        redo if change > c
      end

      result
    rescue => e
      return e.message
    end
  end

  private

  def get_drink_price(price)
    if drink_price = DRINKS_WITH_PRICES[price]
      drink_price
    else
      raise ArgumentError, "Please, enter drinks from list: #{DRINKS_WITH_PRICES.keys.join(', ')}"
    end
  end

  def get_amount(amount)
    if amount && amount > 0
      amount * 100
    else
      raise ArgumentError, 'Please, enter amount'
    end
  end

  def check_remaining_coins
    coins_sum = 0
    @remaining_coins.each { |k,v| coins_sum += k*v }

    if @drink_price > coins_sum
      raise 'Sorry, machine has no money'
    end
  end
end

example = DrinkMachine.new

p '---------- With invalid data -----------'
DrinkMachine::DRINKS_WITH_PRICES.each do |k,_|
  p example.buy
  p example.buy(item: :ads)
  p example.buy(item: k)
  p example.buy(item: k, amount: -1)
  p example.buy(item: k, amount: 0)
  p example.buy(item: k, amount: 2)
  p example.buy(item: k, amount: 2.50)
end
p '--- --- --- --- --- --- --- --- --- ---'
p '----------- With valid data -----------'

DrinkMachine::DRINKS_WITH_PRICES.each do |k,_|
  [6, 6.50, 5.10, 10, 4.90].each { |c| p example.buy(item: k, amount: c) }
end
p '--- --- --- --- --- --- --- --- --- ---'
