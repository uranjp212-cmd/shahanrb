class MplsRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :mpls, reading: :mpls }
end
