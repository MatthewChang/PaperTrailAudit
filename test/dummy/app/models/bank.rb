require 'paper_trail'

class Bank < ApplicationRecord
  belongs_to :user

  has_paper_trail
  paper_trail_audit_for :user,:value
end
