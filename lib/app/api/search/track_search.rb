module Api
  module Search
    class TrackSearch
      attr_reader :query

      def initialize(search_query)
        @query = search_query
      end

      def result
        @result ||= Track.search { fulltext query }
      end

      def entity
        Entity.new(self)
      end

      class Entity < Grape::Entity
        expose :search do
          expose :query do |search, _options|
            search.query
          end
          expose :page do |search, _options|
            search.result.hits.current_page
          end
          expose :per_page do |search, _options|
            search.result.hits.per_page
          end
          expose :count do |search, _options|
            search.result.total
          end
          expose :track_ids do |search, _options|
            search.result.hits.map { |hit| hit.stored(:id) }
          end
        end
        expose :tracks, using: Track::Entity do |search, _options|
          search.result.results
        end
      end
    end
  end
end