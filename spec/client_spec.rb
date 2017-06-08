require 'spec_helper'

describe TNTApi::Client do
  describe ".configuration" do
    let(:client) { TNTApi::Client }
    let(:config) { client.config }

    context "defaults" do
      before  do
        client.configure do |config|
          # do nothing
        end
      end

      it 'should have a default service_endpoint' do
        expect(config.service_endpoint).to eq "http://www.tnt.fr/service/"
      end

      it 'should have a default service_wsdl' do
        expect(config.service_wsdl).to eq "https://www.tnt.fr/service/?wsdl"
      end
    end

    context "configurable attributes" do
      let(:logger) { Logger.new(STDOUT) }

      before do
        client.configure do |config|
          config.username = 'mr_test'
          config.password = 'password'
          config.service_endpoint = 'test_service_endpoint'
          config.service_wsdl = 'test_service_wsdl'
          config.logger = logger
          config.account_number = 123456
        end
      end

      it 'should set the username' do
        expect(config.username).to eq 'mr_test'
      end

      it 'should set the password' do
        expect(config.password).to eq 'password'
      end

      it 'should have a configurable service_endpoint' do
        expect(config.service_endpoint).to eq 'test_service_endpoint'
      end

      it 'should have a configurable service_wsdl' do
        expect(config.service_wsdl).to eq 'test_service_wsdl'
      end

      it 'should have a configurable logger' do
        expect(config.logger).to eq logger
      end

      it 'should have a configurable account_number' do
        expect(config.account_number).to eq 123456
      end
    end
  end
end
