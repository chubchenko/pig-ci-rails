# frozen_string_literal: true

require 'spec_helper'

describe PigCI::Api do
  let(:api) { PigCI::Api.new }

  describe '#headers' do
    subject { api.headers }

    it do
      is_expected.to eq('X-ApiKey': nil)
    end

    context 'with API key set' do
      before { PigCI.api_key = 'api-key' }
      after { PigCI.api_key = nil }

      it do
        is_expected.to eq('X-ApiKey': 'api-key')
      end
    end
  end
end