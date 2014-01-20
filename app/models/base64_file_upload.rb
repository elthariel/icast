require 'base64'

class Base64FileUpload < StringIO
  attr_reader :content_type, :original_filename
  # The hash must have at least three keys :
  #   - base64: the base64 encoded string representation of the file
  #   - filename: the original name of the file
  #   - content_type: The original content type of the file
  def initialize(hash)
    super Base64.decode64(hash[:base64])

    @original_filename  = hash[:filename]
    @content_type       = hash[:content_type]
  end
end
