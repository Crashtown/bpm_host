module Api
  module Search
    class TrackSearch
      def initialize(search_query)
        @query = search_query
      end

      def result
        @result ||= Track.search { fulltext query }
      end

      def entity
        Entity.new(self)
      end

      private

      def query
        @query
      end

      class Entity < Grape::Entity
        expose :search do
          expose :id do |search, options|
            search.result.hits.current_page
          end
          expose :page do |search, options|
            search.result.hits.current_page
          end
          expose :per_page do |search, options|
            search.result.hits.per_page
          end
          expose :count do |search, options|
            search.result.total
          end
          expose :track_ids do |search, options|
            search.result.hits.map{|hit| hit.stored(:id)}
          end
        end
        expose :tracks, using: Track::Entity do |search, options|
          search.result.results
        end
      end
    end
  end
end