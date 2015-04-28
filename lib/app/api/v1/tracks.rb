module API
  module V1
    class Tracks < Grape::API
      include API::V1::Defaults

      namespace 'tracks' do

        desc "Search"
        params do
          requires :query, type: String, desc: 'query string'
        end
        get 'search/:query', desc: 'return search results' do
          present Api::Search::TrackSearch.new(permitted_params[:query])
        end

        desc 'Return all tracks'
        params do
          optional :ids, type: Array[Integer], desc: 'IDs of the tracks'
          optional 'ids[]', type: Integer, desc: 'ID of the track'
        end
        get '/', desc: 'wow' do
          if permitted_params[:ids]
            present Track.where(id: permitted_params[:ids])
          else
            present Track.limit(20)
          end
        end

        desc 'Return a track'
        params do
          requires :id, type: Integer, desc: 'ID of the track'
        end
        get '/:id' do
          present Track.where(id: permitted_params[:id]).first!
        end

        desc 'Update track'
        params do
          requires :track, type: Hash do
            requires :id, type: Integer
            optional :trackNumberTag, type: Integer
            optional :titleTag, type: String
            optional :albumTag, type: String
            optional :yearTag, type: Integer
            optional :genreTag, type: String
          end
        end
        put '/:id' do
          track = Track.find(permitted_params[:track][:id])
          if track.update(extract_track_attributes(permitted_params[:track]))
            present track
          else
            error! :unprocessable_entity
          end
        end
      end

      private

      def extract_track_attributes(track_params)
        res = {}
        res[:album_tag] = track_params[:albumTag] if track_params[:albumTag].present?
        res[:artist_tag] = track_params[:artistTag] if track_params[:artistTag].present?
        res[:year_tag] = track_params[:yearTag] if track_params[:yearTag].present?
        res[:genre_tag] = track_params[:genreTag] if track_params[:genreTag].present?
        res[:title_tag] = track_params[:titleTag] if track_params[:titleTag].present?
        res[:track_number_tag] = track_params[:trackNumberTag] if track_params[:trackNumberTag].present?
        res
      end  
    end
  end
end
