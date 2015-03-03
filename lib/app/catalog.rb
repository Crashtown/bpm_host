require 'mp3info'

class Catalog

  class << self
    def import_path(path)
      entries = Dir.entries(path) - ['.', '..']
      path.each_child do |file_path|
        self.import_path(file_path) if file_path.directory?
        import_track(file_path, path) if file_path.extname == '.mp3'
      end
    end

    private

      def import_track(track_path, track_directory)
        tag_info = Mp3Info.open(track_path).tag.symbolize_keys
        ActiveRecord::Base.transaction do
          artist = Artist.find_or_create_by(name: tag_info[:artist])
          album = Album.find_or_create_by(name: tag_info[:album], year: tag_info[:year])
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
  end
  
end
