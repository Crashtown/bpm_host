require 'rails_helper'

describe 'API::Tracks endpoint', type: :request do
  describe "GET /api/v1/tracks" do
    it "returns first 20 tracks" do
      get "/api/v1/tracks"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq []
    end
  end
  describe "GET /api/track/:id" do
    it "returns a track by id" do
      track = Track.create!
      get "/api/v1/track/#{track.id}"
      expect(response.body).to eq track.entity.to_json
    end
  end
end