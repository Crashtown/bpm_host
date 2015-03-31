require 'mp3info'

class Track < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist

  def entity
    Entity.new(self)
  end

  def write_tag(tag_info)
    tag_hash = tag_info.stringify_keys
    Mp3Info.open(filepath) do |track|
      track.tag1 = tag_hash
    end
  end

  class Entity < Grape::Entity
    root 'tracks', 'track'
    expose :id
    expose :trackNumberTag do |track, options|
      track.track_number_tag
    end
    expose :titleTag do |track, options|
      track.title_tag
    end
    expose :albumTag do |track, options|
      track.album_tag
    end
    expose :yearTag do |track, options|
      track.year_tag
    end
  end
end
