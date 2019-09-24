require 'spec_helper'

RSpec.describe 'Binance Futures integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:market) { 'binance_futures' }
  let(:btc_usdt_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'USDT', market: market, inst_id: 'BTCUSDT') }

  it 'fetch pairs' do
    pairs = client.pairs(market)
    expect(pairs).not_to be_empty
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url market, base: btc_usdt_pair.base, target: btc_usdt_pair.target
    expect(trade_page_url).to eq "https://www.binance.com/en/futures/#{btc_usdt_pair.base}#{btc_usdt_pair.target}"
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_usdt_pair)
    expect(ticker.base).to eq btc_usdt_pair.base
    expect(ticker.target).to eq btc_usdt_pair.target
    expect(ticker.market).to eq market

    expect(ticker.volume).to be_a Numeric
    expect(ticker.last).to be_a Numeric
    expect(ticker.timestamp).to be nil

    expect(ticker.start_timestamp).to be nil #perpetual
    expect(ticker.expire_timestamp).to be nil #perpetual
    expect(ticker.open_interest).to be nil #not_available
    expect(ticker.index).to be_a Numeric
    expect(ticker.funding_rate).to be_a Numeric
    expect(ticker.funding_rate_timestamp).to be_a Numeric
    expect(ticker.next_funding_rate_predicted).to be nil #not_available

    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(btc_usdt_pair)

    expect(order_book.base).to eq btc_usdt_pair.base
    expect(order_book.target).to eq btc_usdt_pair.target
    expect(order_book.market).to eq market

    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be_nil
    expect(order_book.payload).to_not be nil
  end
end
