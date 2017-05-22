require 'spec_helper'

describe TntApi::Client do
  describe ".configuration" do
    let(:client) { TntApi::Client }
    let(:config) { client.config }

    before do
      client.configure do |config|
        config.username = 'mr_test'
        config.password = 'password'
      end
    end

    it 'should set the username' do
      expect(config.username).to eq 'mr_test'
    end

    it 'should set the password' do
      expect(config.password).to eq 'password'
    end
  end
end
