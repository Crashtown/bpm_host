require "grape-swagger"

module API
  module V1
    class Root < Grape::API
      mount API::V1::Search
      mount API::V1::Tracks
      mount API::V1::Albums
      mount API::V1::Artists
      # mount API::V1::AnotherResource

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
