class IcyHeaders < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::IndifferentAccess

  HEADERS = ['icy-name', 'icy-genre', 'icy-url', 'icy-br', 'content-type']

  attr_reader :raw

  def initialize(raw_headers)
    super(nil)

    @raw = raw_headers

    HEADERS.each do |header|
      matches = Regexp.new("^#{header}:(.*)$").match self.raw
      self[header.underscore] = matches[1].strip if matches
    end rescue nil
  end
end
