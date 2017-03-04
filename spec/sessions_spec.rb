require 'spec_helper'
require_relative '../lib/sessions.rb'

describe '#current' do
  before do
    new_time = Time.local(2017, 3, 20, 15, 40, 0)
    Timecop.freeze(new_time)
  end

  let(:mock_sessions) do
    [{ module: '4TPM201U Algebre lineaire',
       date: '20/03/2017',
       time: '11:00',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TPM206U Initiation a la programmation en C',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TMQ401U Structures algebriques 1',
       date: '20/03/2017',
       time: '17:00',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' }]
  end

  let(:current_session) { Sessions.current(mock_sessions) }

  it 'returns the current session' do
    expect(current_session[:module])
      .to eq '4TPM206U Initiation a la programmation en C'
  end
  it 'does not return previous sessions' do
    expect(current_session[:module])
      .not_to eq '4TMQ401U Structures algebriques 1'
  end
  it 'does not return the session after the next one' do
    expect(current_session[:module]).not_to eq '4TPM201U Algebre lineaire'
  end

  describe 'when there is no current one' do
    it 'does not return anything' do
      current_session = Sessions.current([])
      expect(current_session).to be_nil
    end
  end
end

describe '#followed' do
  let(:mock_sessions) do
    [{ module: '4TPM201U Algebre lineaire',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TPM206U Initiation a la programmation en C',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TMQ401U Structures algebriques 1',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TTI603U Arithmetique et crypto',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TTI601U Codes correcteurs',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TPM209U Analyse',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' }]
  end

  let(:filtered_sessions) { Sessions.followed(mock_sessions) }

  let(:filtered_sessions_names) do
    filtered_sessions.map do |session|
      session[:module]
    end
  end

  it 'keeps "Algebre lineaire"' do
    expect(filtered_sessions_names).to include '4TPM201U Algebre lineaire'
  end
  it 'keeps "Initiation a la programmation en C"' do
    expect(filtered_sessions_names)
      .to include '4TPM206U Initiation a la programmation en C'
  end
  it 'keeps "Structures algebriques 1"' do
    expect(filtered_sessions_names)
      .to include '4TMQ401U Structures algebriques 1'
  end
  it 'keeps "Arithmetique et crypto"' do
    expect(filtered_sessions_names).to include '4TTI603U Arithmetique et crypto'
  end
  it 'keeps "Codes correcteurs"' do
    expect(filtered_sessions_names).to include '4TTI601U Codes correcteurs'
  end
  it 'does not keep "Analyse"' do
    expect(filtered_sessions_names).not_to include '4TPM209U Analyse'
  end
end

describe '#todays' do
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

  let(:todays_sessions) { Sessions.todays(mock_sessions) }

  let(:todays_sessions_names) do
    todays_sessions.map do |session|
      session[:module]
    end
  end

  it "returns today's sessions" do
    expect(todays_sessions_names).to include '4TPM201U Algebre lineaire'
  end
  it "does not return another day's session" do
    expect(todays_sessions_names).not_to include '4TPM209U Analyse'
  end

  after do
    Timecop.return
  end
end

describe '#next' do
  before do
    new_time = Time.local(2017, 3, 20, 12, 0, 0)
    Timecop.freeze(new_time)
  end

  let(:mock_sessions) do
    [{ module: '4TPM201U Algebre lineaire',
       date: '20/03/2017',
       time: '11:00',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TPM206U Initiation a la programmation en C',
       date: '20/03/2017',
       time: '15:30',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' },
     { module: '4TMQ401U Structures algebriques 1',
       date: '20/03/2017',
       time: '17:00',
       room: 'A22/Amphith\u00E9\u00E2tre Henri POINCARE' }]
  end

  let(:next_session) { Sessions.next(mock_sessions) }

  it 'returns the next session' do
    expect(next_session[:module])
      .to eq '4TPM206U Initiation a la programmation en C'
  end
  it 'does not return previous sessions' do
    expect(next_session[:module]).not_to eq '4TPM201U Algebre lineaire'
  end
  it 'does not return the session after the next one' do
    expect(next_session[:module]).not_to eq '4TMQ401U Structures algebriques 1'
  end
end
