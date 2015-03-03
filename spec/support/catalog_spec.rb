require 'rails_helper'

RSpec.describe Catalog do

  let(:va_path) do
    path = File.join(Rails.root, 'spec', 'fixtures', 'mp3', 'VA')
    Pathname.new(path)
  end

  let(:root_path) do
    path = File.join(Rails.root, 'spec', 'fixtures', 'mp3')
    Pathname.new(path)
  end

  it 'import tracks' do
    expect{
      Catalog.import_path(va_path)
    }.to change{Track.count}.from(0).to(2)
  end

  it 'import artist' do
    expect{
      Catalog.import_path(va_path)
    }.to change{Artist.count}.from(0).to(2)
  end

  it 'import album' do
    expect{
      Catalog.import_path(va_path)
    }.to change{Album.count}.from(0).to(1)
  end

end
