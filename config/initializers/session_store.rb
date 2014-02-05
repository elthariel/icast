# Be sure to restart your server when you modify this file.

Radioxide::Application.config.session_store :cookie_store,
  key: '_radioxide_session', httponly: false
