module Exceptions
  class AnswersCorrectnessError < StandardError; end
  class AnswersVisibilityError < StandardError; end

  # Chybajuci kluc v Hashi.
  class MissingKeyError < StandardError; end

  # use this when ENV variables are missing
  class ApplicationConfigurationIncomplete < StandardError
    def message
      "Application cofiguration is incomplete. Fill in 'config/application.yml' or set ENVs. #{@message}"
    end
  end
end