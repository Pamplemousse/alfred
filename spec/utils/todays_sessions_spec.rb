require 'spec_helper'
require_relative '../../lib/utils'

describe 'todays_sessions()' do
  before do
    date = Date.new(2017, 3, 20)
    Timecop.freeze(date)
  end

  let(:mock_sessions) do
    [{ module: '4TPM201U Algebre lineaire',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TPM209U Analyse',
       date: '21/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' }]
  end

  let(:days_sessions) { todays_sessions(mock_sessions) }

  let(:days_sessions_names) do
    days_sessions.map do |session|
      session[:module]
    end
  end

  it "returns today's sessions" do
    expect(days_sessions_names).to include '4TPM201U Algebre lineaire'
  end
  it "does not return another day's session" do
    expect(days_sessions_names).not_to include '4TPM209U Analyse'
  end

  after do
    Timecop.return
  end
end
