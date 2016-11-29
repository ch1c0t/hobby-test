if defined? Mutant::Selector
  class Mutant::Selector::Expression
    def call _subject
      integration.all_tests
    end
  end
end
