module API
  module V1
    class Artists < Grape::API
      include API::V1::Defaults

      namespace 'artists' do

        desc "Return all artists"
        params do
          optional :ids, type: Array[Integer], desc: 'IDs of the artists'
          optional 'ids[]', type: Integer, desc: 'ID of the artist'
        end
        get '/', desc: 'return artists' do
          if permitted_params[:ids]
            present Artist.where(id: permitted_params[:ids])
          else
            present Artist.limit(20)
          end
        end

        desc "Return a artist"
        params do
          optional :id, type: Integer, desc: "ID of the artist"
        end
        get '/:id' do
          present Artist.where(id: permitted_params[:id]).first!
        end

        desc 'Update artist'
        params do
          requires :artist, type: Hash do
            requires :id, type: Integer
            optional :name, type: String
          end
        end
        put '/:id' do
          artist = Artist.find(permitted_params[:artist][:id])
          if artist.update(permitted_params[:artist])
            present artist
          else
            error! :unprocessable_entity
          end
        end
      end
    end
  end
end
