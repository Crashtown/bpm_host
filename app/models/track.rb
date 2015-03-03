class Track < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :title do |track, options|
      track.title_tag
    end
  end
end
