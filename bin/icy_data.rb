#! /usr/bin/env ruby

require 'socket'
require 'uri'

uri = URI(ARGV[0])
out_path = ARGV[1]
http_path = uri.path == "" ? "/" : uri.path

puts "Connecting to #{uri.host}:#{uri.port}, path is #{http_path}"
socket = TCPSocket.new uri.host, uri.port

socket.send "GET #{http_path} HTTP/1.0\r\n\r\n", 0

data = ''
while line = socket.gets and line.strip != "" and data.size < 1024
  data = data + line
end

File.open(out_path, 'w') do |f|
  f.write data
end

socket.close             # close socket when done
