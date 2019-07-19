# frozen_string_literal: true

require 'spec_helper'

describe PigCI::ProfilerEngine do
  let(:profiler_engine) { PigCI::ProfilerEngine::Rails.new }

  before do
    # Stub out the complex eager loading a little
    allow(Rails.application).to receive(:call)
  end

  describe '#profilers' do
    subject { profiler_engine.profilers }
    it { expect(subject.count).to eq(3) }
  end

  describe '#reports' do
    subject { profiler_engine.reports }
    it { expect(subject.count).to eq(3) }
  end

  describe '::ActiveSupport::Notifications' do
    let(:payload) do
      {
        method: 'GET',
        controller: 'SampleController',
        action: 'index',
        format: 'html'
      }
    end
    before { profiler_engine.setup! }
    after do
      ActiveSupport::Notifications.unsubscribe('start_processing.action_controller')
      ActiveSupport::Notifications.unsubscribe('instantiation.active_record')
      ActiveSupport::Notifications.unsubscribe('sql.active_record')
      ActiveSupport::Notifications.unsubscribe('process_action.action_controller')
    end

    describe 'start_processing.action_controller' do
      subject do
        ActiveSupport::Notifications.instrument('start_processing.action_controller', payload) {}
      end

      it do
        profiler_engine.profilers.each do |profiler|
          expect(profiler).to receive(:reset!)
        end

        expect { subject }.to change(profiler_engine, :request_key).from(nil).to('GET SampleController#index{format:html}')
      end
    end

    describe 'sql.active_record' do
      let(:profiler_database_request) do
        profiler_engine.profilers.select { |profiler| profiler.class == PigCI::Profiler::DatabaseRequest }.first
      end
      let(:payload) {}

      subject do
        ActiveSupport::Notifications.instrument('sql.active_record', payload) {}
      end

      it do
        expect(profiler_database_request).to_not receive(:increment!)
        subject
      end

      context 'with a request_key set' do
        before { profiler_engine.request_key = 'request-key' }

        it do
          expect(profiler_database_request).to receive(:increment!)
          subject
        end
      end
    end

    describe 'process_action.action_controller' do
      let(:payload) {}
      before do
        profiler_engine.request_key = 'request-key'
      end

      subject do
        ActiveSupport::Notifications.instrument('process_action.action_controller', payload) {}
      end

      it do
        profiler_engine.profilers.each do |profiler|
          expect(profiler).to receive(:log_request!)
        end

        expect { subject }.to change(profiler_engine, :request_captured).from(false).to(true)
                                                                        .and change(profiler_engine, :request_key).from('request-key').to(nil)
      end
    end
  end
end
