require 'rails_helper'

describe 'API::Tracks endpoint', type: :request do
  describe "GET /api/v1/tracks" do
    it "returns first 20 tracks" do
      get "/api/v1/tracks"
      expect(response.status).to eq(200)
      expect(response.body).to eq ({'tracks'=> []}.to_json)
    end
  end
  describe "GET /api/v1/tracks/:id" do
    it "returns a track entity by id" do
      track = Track.create!
      get "/api/v1/tracks/#{track.id}"
      expect(response.status).to eq(200)
      expect(response.body).to eq ({'track' => track.entity}.to_json)
    end
  end
end