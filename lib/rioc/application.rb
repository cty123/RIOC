require 'rioc/errors'

module Rioc

  # RiocApplication class
  class RiocApplication

    # This function should be implemented by user
    def application_start
      raise Errors::ApplicationUndeclaredError
    end

  end

end
