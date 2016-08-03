module PaperTrailAudit
  class Change
    include ActiveModel::Model
    attr_accessor :old_value, :new_value, :time
    # validates [:old_value,:new_value,:time], presence: true
    # validates :next, presence: true
    # validates :time, presence: true
    def ==(other)
      self.old_value == other.old_value &&
      self.new_value == other.new_value &&
      self.time == other.time
    end
  end
end
