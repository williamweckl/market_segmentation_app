require 'billy'

Billy.configure do |c|
  # configuration options
  # c.cache = false
end

Billy.register_drivers

module Billy
  module MinitestHelper
    def proxy
      Billy.proxy
    end
  end
end