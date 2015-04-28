require 'mp3info'
require 'fileutils'

class Catalog
  class << self
    def import_path(path)
      entries = Dir.entries(path) - ['.', '..']
      path.each_child do |file_path|
        self.import_path(file_path) if file_path.directory?
        import_track(file_path, path) if mp3_file?(file_path)
        # import_cover(file_path, path) if cover_file?(file_path)
      end
    end

    def export_path(path)
      fail ArgumentError.new, 'somth is baaaad' unless path.directory?
      FileUtils.cd path
      Artist.each do |artist|
        FileUtils.mkdir artist.name
        FileUtils.cd artist.name do
          artist.albums.each do |album|
            FileUtils.mkdir album.name
            FileUtils.cd album.name do
              album.tracks.each do |track|
                FileUtils.cp track.filepath, track.title_tag
              end
            end
          end
        end
      end
    end

    private

    def mp3_file?(file_path)
      file_path.extname == '.mp3' || file_path.extname == '.MP3'
    end

    def cover_file?(file_path)
      image_extension?(file_path.extname) && file_path.basename == 'cover'
    end

    def image_extension?(file_extension)
      file_extension == '.jpg' || file_extension == '.jpеg' ||
      file_extension == '.JPG' || file_extension == '.JPEG' ||
      file_extension == '.png' || file_extension == '.gif' ||
      file_extension == '.PNG' || file_extension == '.GIF' ||
      file_extension == '.bmp' || file_extension == '.BMP'
    end

    def import_track(track_path, track_directory)
      tag_info = meta_data(track_path)
      ActiveRecord::Base.transaction do
        artist = Artist.find_or_create_by(name: tag_info[:artist])
        album = Album.find_or_create_by(name: tag_info[:album],
                                        year: tag_info[:year])
        Track.find_or_create_by(
          album: album,
          artist: artist,
          filepath: track_path.to_s,
          album_tag: tag_info[:album],
          artist_tag: tag_info[:artist],
          year_tag: tag_info[:year],
          genre_tag: tag_info[:genre],
          title_tag: tag_info[:title],
          track_number_tag: tag_info[:tracknum]
        )
      end
    end

    def meta_data(track_path)
      Mp3Info.open(track_path) do |mp3info|
        mp3info.tag.symbolize_keys
      end
    end
  end
end
