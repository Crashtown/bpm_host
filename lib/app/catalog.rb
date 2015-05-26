require 'mp3info'
require 'fileutils'

class Catalog

  class << self
    ILLEGAL_CHARS_EXPRESSION = /[^\w `#`~!@''\$%&\(\)_\-\+=\[\]\{\};,\.]/
    
    def import_path(path)
      path.each_child do |file_path|
        import_path(file_path) if file_path.directory?
        import_track(file_path, path) if mp3_file?(file_path)
        import_cover(file_path, path) if cover_file?(file_path)
      end
    end

    def export_path(path)
      fail ArgumentError.new, 'VRONG VRONG RAISE UR DONGERS' unless path.directory?
      Artist.each { export_artist(artist, path) }
    end

    private

    def sanitize_filename(filename)
      if illegal_chars?(filename) 
        filename.gsub(ILLEGAL_CHARS_EXPRESSION, '')
      else
        filename
      end
    end

    def illegal_chars?(filename)
      filename =~ ILLEGAL_CHARS_EXPRESSION
    end

    def export_artist(artist, path)
      FileUtils.cd path
      filename = sanitize_filename(artist.name)
      artist_catalog = path + filename
      FileUtils.mkdir artist_catalog
      artist.albums.each { |album| export_album(album, artist_catalog) }
    end

    def export_album(album, path)
      FileUtils.cd path
      filename = sanitize_filename(album.name)
      album_catalog = path + filename
      FileUtils.mkdir album_catalog
      album.tracks.each { |track| export_track(track, album_catalog) }
      album.update_attribute(:filepath, album_catalog)
    end

    def export_track(track, path)
      FileUtils.cd path
      filename = sanitize_filename(track_title_tag)
      track_catalog = path + filename
      FileUtils.cp track.filepath, track_catalog
      track.update_attribute(:filepath, track_catalog)
    end

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
        album = Album.find_or_create_by(filepath: track_directory.to_s)
        album.update_attribute(:name, tag_info[:album]) if album.name.nil?
        album.update_attribute(:year, tag_info[:year]) if album.year.nil?
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

    def import_cover(cover_path, track_directory)
      album = Album.find_or_create_by(filepath: track_directory.to_s)
      album.update_attribute(
        :covers, (album.covers |= [track_directory.to_s]).sort
      )
    end

    def meta_data(track_path)
      Mp3Info.open(track_path) do |mp3info|
        mp3info.tag.symbolize_keys
      end
    end
  end
end
