module API
  module V1
    class Albums < Grape::API
      include API::V1::Defaults

      namespace 'albums' do

        desc "Return all albums"
        params do
          optional :ids, type: Array[Integer], desc: 'IDs of the albums'
          optional 'ids[]', type: Integer, desc: 'ID of the album'
        end
        get '/', desc: 'return albums' do
          if permitted_params[:ids]
            present Album.where(id: permitted_params[:ids])
          else
            present Album.limit(20)
          end
        end

        desc "Return a album"
        params do
          optional :id, type: Integer, desc: "ID of the album"
        end
        get '/:id' do
          present Album.where(id: permitted_params[:id]).first!
        end

      end
    end
  end
end
