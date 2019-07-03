# frozen_string_literal: true

require 'spec_helper'

describe PigCI::Api::Reports do
  let(:reports) do
    [
      PigCI::Report.new(i18n_key: 'profiler', historical_log_file: File.join('spec', 'fixtures', 'files', 'profiler.json'))
    ]
  end
  let(:api) { PigCI::Api::Reports.new(reports: reports) }
  before { PigCI.api_key = 'api-key' }
  after { PigCI.api_key = nil }

  describe '#share!' do
    subject { api.share! }

    before do
      stub_request(:post, 'https://api.pigci.com/v1/reports')
        .to_return(status: 200, body: '', headers: {})
    end

    it 'makes the API request with valid JSON as param' do
      subject

      expect(a_request(:post, 'https://api.pigci.com/v1/reports').with do |req|
        params = CGI.parse(req.body)

        expect(params['commit_sha1']).to eq(['test_sha1'])
        expect(params['head_branch']).to eq(['test/branch'])
        expect(params['reports[]'].first).to match_response_schema('reports')
      end).to have_been_made
    end
  end
end