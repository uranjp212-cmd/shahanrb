class Ff2Record < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :ff2, reading: :ff2 }
end
