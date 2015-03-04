module API
  module V1
    class Tracks < Grape::API
      include API::V1::Defaults

      namespace 'tracks' do
        desc "Return all tracks"
        get '/', desc: 'wow' do
          Track.limit(20)
        end

        desc "Return a track"
        params do
          requires :id, type: String, desc: "ID of the track"
        end
        get '/:id' do
          present Track.where(id: permitted_params[:id]).first!
        end
      end
    end
  end
end
