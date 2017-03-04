require 'spec_helper'
require_relative '../../lib/utils'

describe 'next_session()' do
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

  let(:session) { next_session(mock_sessions) }

  it 'returns next session' do
    expect(session[:module])
      .to eq '4TPM206U Initiation a la programmation en C'
  end
  it 'does not return previous sessions' do
    expect(session[:module]).not_to eq '4TPM201U Algebre lineaire'
  end
  it 'does not return the session after the next one' do
    expect(session[:module]).not_to eq '4TMQ401U Structures algebriques 1'
  end
end