require 'mp3info'

class Track < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist

  after_update :write_tags


  def entity
    Entity.new(self)
  end

  private

  def write_tags
    return unless tags_changed?
    tag_hash = tag_info
    Mp3Info.open(self[:filepath]) do |track|
      track.tag1 = tag_hash
    end
  end

  def tags_changed?
    album_tag_changed? || artist_tag_changed? || track_number_tag_changed? ||
    title_tag_changed? || year_tag_changed? || genre_tag_changed? 
  end

  def tag_info
    { 
      'album' => self[:album_tag],
      'artist' => self[:artist_tag],
      'year' => self[:year_tag],
      'genre' => self[:genre_tag],
      'title' => self[:title_tag],
      'tracknum' => self[:track_number_tag]
    }
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
    expose :genreTag do |track, options|
      track.genre_tag
    end
    expose :album do |track, options|
      track.album_id
    end
    expose :artist do |track, options|
      track.artist_id
    end
  end

  searchable do
    text :filepath, :title_tag, :genre_tag
    integer :year_tag
    integer :id, stored: true
  end
end
