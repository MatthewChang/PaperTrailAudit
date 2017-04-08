require 'paper_trail'

# object with no table
class Miss < ActiveRecord::Base
  has_paper_trail
  paper_trail_audit_for :value
end
