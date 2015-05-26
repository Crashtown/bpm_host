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

        desc 'Update album'
        params do
          requires :album, type: Hash do
            requires :id, type: Integer
            optional :name, type: String
            optional :year, type: Integer
          end
        end
        put '/:id' do
          album = Album.find(permitted_params[:album][:id])
          if album.update(permitted_params[:album])
            present album
          else
            error! :unprocessable_entity
          end
        end

        desc 'Return albums cover'
        params do
          requires :id, type: Integer
        end
        get '/:id/cover' do
          album = Album.find(permitted_params[:id])
          filename = album.selected_cover
          content_type MIME::Types.type_for(filename).to_s
          env['api.format'] = :binary
          header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(filename)}"
          File.read(filename)
        end
      end
    end
  end
end
