require 'rails_helper'

describe 'API::Albums endpoint', type: :request do
  describe "GET /api/v1/albums" do
    it "returns first 20 albums" do
      get "/api/v1/albums"
      expect(response.status).to eq(200)
      expect(response.body).to eq ({'albums'=> []}.to_json)
    end
  end
  describe "GET /api/v1/albums/:id" do
    it "returns a album entity by id" do
      album = Album.create!
      get "/api/v1/albums/#{album.id}"
      expect(response.status).to eq(200)
      expect(response.body).to eq ({'album' => album.entity}.to_json)
    end
  end
end