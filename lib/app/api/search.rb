module Api
  class Search
    attr_reader :query

    def initialize(query:)
      @query = query
    end

    def result
      @result ||= search
    end

    def entity
      Entity.new(self)
    end

    private

    def search
      track_search = Track.search { fulltext query }
      album_search = Album.search { fulltext query } 
      artist_search = Artist.search { fulltext query }
      {
        count: (
          track_search.total + 
          album_search.total + 
          artist_search.total 
        ), 
        track_ids: track_search.hits.map{|hit| hit.stored(:id)},
        album_ids: album_search.hits.map{|hit| hit.stored(:id)},
        artist_ids: artist_search.hits.map{|hit| hit.stored(:id)}
      }
    end

    class Entity < Grape::Entity
      expose :albums do |search, options|
        search.result[:album_ids]
      end
      expose :tracks do |search, options|
        search.result[:track_ids]
      end
      expose :artists do |search, options|
        search.result[:artist_ids]
      end
      expose :resultCount do |search, options|
        search.result[:count]
      end
    end
  end
end
