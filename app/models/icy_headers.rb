require 'socket'
require 'uri'

class IcyHeaders < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::IndifferentAccess

  HEADERS = [
    'icy-name',
    'icy-genre',
    'icy-url',
    'icy-br',
    'icy-description',
    'content-type',
    'Content-Type'
  ]

  attr_reader :raw

  def initialize(raw_headers)
    super(nil)

    @raw = raw_headers

    HEADERS.each do |header|
      matches = Regexp.new("^#{header}:(.*)$").match self.raw
      self[header.underscore] = matches[1].strip if matches
    end rescue nil
  end

  def self.from_uri(uri)
    uri = URI(uri)
    http_path = uri.path == "" ? "/" : uri.path
    socket = TCPSocket.new uri.host, uri.port
    socket.send "GET #{http_path} HTTP/1.0\r\n\r\n", 0

    data = ''
    while line = socket.gets and line.strip != "" and data.size < 1024
      data = data + line
    end
    socket.close

    self.new(data)
  end
end
