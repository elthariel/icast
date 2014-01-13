module IcecastConstraints
  module Add
    extend self
    def matches?(request)
      request.env['rack.request.form_hash']['action'] == 'add'
    end
  end
  module Touch
    extend self
    def matches?(request)
      request.env['rack.request.form_hash']['action'] == 'touch'
    end
  end
  module Remove
    extend self
    def matches?(request)
       request.env['rack.request.form_hash']['action'] == 'remove'
    end
  end
end
