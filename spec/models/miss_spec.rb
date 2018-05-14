require 'spec_helper'

RSpec.describe Miss, type: :model do
  before(:each) do
    PaperTrail.request.whodunnit = nil
  end
  describe 'Model with no table' do
    it 'is able to load code without error' do
      expect(Miss.instance_methods).to include(:value_changes)
    end
  end
end
