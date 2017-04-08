class User < ActiveRecord::Base
  enum state: {
    happy: 0,
    sad: 1,
    neutral: 2
  }

  has_paper_trail
  # the column "empty" doesn't exist
  paper_trail_audit_for :state, :empty
end
