require 'rails_helper'

RSpec.describe Track, type: :model do
  describe '#write_tag' do

    fixtures :tracks

    let(:fake_tag) do
      { album: 'azas' }
    end

    it 'calls ruby-mp3info class to handle tag write' do
      mp3info = spy('mp3info')
      allow(Mp3Info).to receive(:open).and_yield(mp3info)
      tracks(:real_track).write_tag(fake_tag)
      expect(mp3info).to have_received(:tag1=)
    end
  end
end
