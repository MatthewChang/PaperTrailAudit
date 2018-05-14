require 'paper_trail'

# object with no table
class Miss < ApplicationRecord
  has_paper_trail
  paper_trail_audit_for :value
end
