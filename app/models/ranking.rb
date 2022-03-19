class Ranking < ApplicationRecord
  enum sex: { boy: 1, girl: 2 }
end
