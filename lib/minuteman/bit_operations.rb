require "minuteman/bit_operations/plain"
require "minuteman/bit_operations/with_data"

class Minuteman
  module BitOperations
    # Public: Checks for the existance of ids on a given set
    #
    #   ids - Array of ids
    #
    def include?(*ids)
      result = ids.map { |id| getbit(id) }
      result.size == 1 ? result.first : result
    end

    # Public: Resets the current key
    #
    def reset
      redis.rem(key)
    end

    # Public: Cheks for the amount of ids stored on the current key
    #
    def length
      redis.bitcount(key)
    end

    # Public: Calculates the NOT of the current key
    #
    def -@
      operation("NOT", key)
    end
    alias :~@ :-@

    # Public: Calculates the substract of one set to another
    #
    #   timespan: Another BitOperations enabled class
    #
    def -(timespan)
      operation("MINUS", timespan)
    end

    # Public: Calculates the XOR against another timespan
    #
    #   timespan: Another BitOperations enabled class
    #
    def ^(timespan)
      operation("XOR", timespan)
    end

    # Public: Calculates the OR against another timespan
    #
    #   timespan: Another BitOperations enabled class or an Array
    #
    def |(timespan)
      operation("OR", timespan)
    end
    alias :+ :|

    # Public: Calculates the AND against another timespan
    #
    #   timespan: Another BitOperations enabled class or an Array
    #
    def &(timespan)
      operation("AND", timespan)
    end

    private

    # Private: Helper to access the value a given bit
    #
    #   id: The bit
    #
    def getbit(id)
      redis.getbit(key, id) == 1
    end

    # Private: Checks if a timespan is operable
    #
    #   timespan: The given timespan
    #
    def operable_timespan(timespan)
      timespan.class.ancestors.include?(BitOperations)
    end

    # Private: returns the class to use for the operation
    #
    #   timespan: The given timespan
    #
    def operation_class(timespan)
      case true
      when timespan.is_a?(Array) then WithData
      when timespan.is_a?(String), operable_timespan(timespan) then Plain
      end
    end

    # Private: executes an operation between the current timespan and another
    #
    #   type:     The operation type
    #   timespan: The given timespan
    #
    def operation(type, timespan)
      if type == "MINUS" && operable_timespan(timespan)
        return self ^ (self & timespan)
      end

      klass = operation_class(timespan)
      klass.new(redis, type, timespan, key).call
    end
  end
end
