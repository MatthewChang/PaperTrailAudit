require 'spec_helper'

RSpec.describe Bank, type: :model do
  it 'tracks initial state' do
    Bank.create(value: 20)
    expect(Bank.last.value_changes).to eq([PaperTrailAudit::Change.new(old_value: nil, new_value: 20, time: Bank.last.updated_at)])
  end
  it 'tracks the state if it was unset at the beginning' do
    @b = Bank.create
    @b.update(value: 10)
    expect(@b.value_changes).to eq([PaperTrailAudit::Change.new(old_value: nil, new_value: 10, time: @b.updated_at)])
  end
  it 'tracks multiple changes' do
      expected = []
      @b = Bank.create(value: 100)
      expected << PaperTrailAudit::Change.new(old_value: nil, new_value: 100, time: @b.updated_at)
      @b.update(value: 10)
      expected << PaperTrailAudit::Change.new(old_value: 100, new_value: 10, time: @b.updated_at)
      @b.update(value: nil)
      expected << PaperTrailAudit::Change.new(old_value: 10, new_value: nil, time: @b.updated_at)
      @b.update(value: 40)
      expected << PaperTrailAudit::Change.new(old_value: nil, new_value: 40, time: @b.updated_at)
      expect(@b.value_changes).to eq(expected)
  end

  it 'tracks only the required changes multiple changes' do
      expected = []
      @b = Bank.create(value: 100)
      expected << PaperTrailAudit::Change.new(old_value: nil, new_value: 100, time: @b.updated_at)
      @b.update(user: User.create)
      @b.update(value: nil)
      expected << PaperTrailAudit::Change.new(old_value: 100, new_value: nil, time: @b.updated_at)
      expect(@b.value_changes).to eq(expected)
  end

  it 'tracks the belongs to relation' do
      expected = []
      @u1 = User.create
      @u2 = User.create
      @b = Bank.create(value: 100)
      @b.update(user: @u1)
      expected << PaperTrailAudit::Change.new(old_value: nil, new_value: @u1, time: @b.updated_at)
      @b.update(user: @u2)
      expected << PaperTrailAudit::Change.new(old_value: @u1, new_value: @u2, time: @b.updated_at)
      @b.update(user: nil)
      expected << PaperTrailAudit::Change.new(old_value: @u2, new_value: nil, time: @b.updated_at)
      expect(@b.user_changes).to eq(expected)
  end
end
