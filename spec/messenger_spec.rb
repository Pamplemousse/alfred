require 'spec_helper'
require_relative '../lib/messenger.rb'

describe '#new' do
  describe 'if the incoming message contains "current"' do
    it 'sets @match to "current"' do
      incoming_message = 'Bonjour Alfred, current'
      messenger = Messenger.new(incoming_message, [])
      expect(messenger.instance_variable_get(:@match)).to eq "current"
    end
    it 'understands even if there is an upper case letter' do
      incoming_message = 'Current'
      messenger = Messenger.new(incoming_message, [])
      expect(messenger.instance_variable_get(:@match)).to eq "current"
    end
  end
  describe 'if the incoming message contains "next"' do
    it 'sets @match to "next"' do
      incoming_message = 'Bonjour Alfred, next'
      messenger = Messenger.new(incoming_message, [])
      expect(messenger.instance_variable_get(:@match)).to eq "next"
    end
    it 'understands even if there is an upper case letter' do
      incoming_message = 'Next'
      messenger = Messenger.new(incoming_message, [])
      expect(messenger.instance_variable_get(:@match)).to eq "next"
    end
  end
  it 'does nothing if there is no match' do
    incoming_message = 'Sorry Alfred, I have incredible reflexes.'
    messenger = Messenger.new(incoming_message, [])
    expect(messenger.instance_variable_get(:@match)).to be_empty
  end
end

describe '.message' do
  let(:session) do
    { module: '4TPM201U Algebre lineaire',
      date: Date.new,
      time: '11:00',
      room: 'A21/Salle 302' }
  end

  let(:generated_message) do
    incoming_message = 'current'
    Messenger.new(incoming_message, []).message
  end

  it 'contains the rooms' do
    allow(Sessions).to receive(:current) { session }
    expect(generated_message).to match(/302/)
  end
  it 'contains the times' do
    allow(Sessions).to receive(:current) { session }
    expect(generated_message).to match(/11:00/)
  end
  it 'contains module names' do
    allow(Sessions).to receive(:current) { session }
    expect(generated_message).to match(/4TPM201U Algebre lineaire/)
  end

  describe 'when there is no match' do
    it 'returns an empty message' do
      generated_message = Messenger.new('yolo alfred', []).message
      expect(generated_message).to be_empty
    end
  end

  describe 'when there are no sessions' do
    it 'returns an empty message' do
      generated_message = Messenger.new('current', []).message
      allow(Sessions).to receive(:current) { nil }
      expect(generated_message).to be_empty
    end
  end
end
