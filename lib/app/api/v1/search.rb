module API
  module V1
    class Search < Grape::API
      include API::V1::Defaults

      desc "Search"
      params do
        requires :query, type: String, desc: 'query string'
      end
      get 'search/:query', desc: 'return search results' do
        present Api::Search.new(query: permitted_params[:query])
      end
    end
  end
end
