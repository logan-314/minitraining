class ConvertToActiveStorageForPictures < ActiveRecord::Migration[5.2]
  require 'open-uri'

  def up
    # Removed in 2026.
  end

  def down
    # Removed.
  end

  private

  def key(instance, attachment)
    SecureRandom.uuid
    # Alternatively:
    # instance.send("#{attachment}_file_name")
  end

  def checksum(attachment)
    # local files stored on disk:
    url = attachment.path
    Digest::MD5.base64digest(File.read(url))
  end
end
