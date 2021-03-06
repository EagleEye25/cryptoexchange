require 'spec_helper'

RSpec.describe 'Buyucoin integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_inr_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'INR', market: 'buyucoin') }

  it 'fetch pairs' do
    pairs = client.pairs('buyucoin')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'buyucoin'
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_inr_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'INR'
    expect(ticker.market).to eq 'buyucoin'
    expect(ticker.last).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end

    it 'fetch order book' do
    order_book = client.order_book(btc_inr_pair)

    expect(order_book.base).to eq 'BTC'
    expect(order_book.target).to eq 'INR'
    expect(order_book.market).to eq 'buyucoin'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.payload).to_not be nil
  end
end
