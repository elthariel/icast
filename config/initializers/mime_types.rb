# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

## Registering Playlist mime types
Mime::Type.register "audio/x-mpegurl",  :m3u
Mime::Type.register "audio/x-scpls",    :pls
