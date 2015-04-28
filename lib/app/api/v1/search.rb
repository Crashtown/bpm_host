module API
  module V1
    class Search < Grape::API
      include API::V1::Defaults

      desc "Search"
      params do
        requires :q, type: String, desc: 'query string'
      end
      get 'search', desc: 'return search results' do
        present Api::Search::TrackSearch.new(permitted_params[:q])
      end
    end
  end
end
