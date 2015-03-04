module API
  module V1
    class Tracks < Grape::API
      include API::V1::Defaults

      namespace 'tracks' do

        desc "Return all tracks"
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

        desc "Return a track"
        params do
          optional :id, type: Integer, desc: "ID of the track"
        end
        get '/:id' do
          present Track.where(id: permitted_params[:id]).first!
        end

      end
    end
  end
end
