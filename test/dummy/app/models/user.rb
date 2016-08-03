class User < ActiveRecord::Base
  enum state: {
    happy: 0,
    sad: 1,
    neutral: 2
  }

  has_paper_trail
  paper_trail_audit_for :state
end
