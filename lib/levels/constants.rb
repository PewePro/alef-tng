module Levels
  class Constants
    # Weights of individual activities
    WEIGHT_SOLVED = 5
    WEIGHT_FAILED = 2
    WEIGHT_DONT_NOW = 1
    WEIGHT_COMMENT = 3

    # Base for the exponential function that which reduces the contribution of  actual comment to the score for the room
    BASE_EXP_FUNCTION = 0.9

    # The minimal percentage success required in the room
    MIN_PERCENTAGE_OF_SUCCESS = 0.6
  end
end