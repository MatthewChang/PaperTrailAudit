# PaperTrailAudit

##Synopsis

This gem is an extension to paper_trail gem https://github.com/airblade/paper_trail. That means you need to pre install paper_trail gem. This gem wraps certain auditing functionality to allow easier change tracking for specific fields on a model.

## Installation

Add this line to your application's `Gemfile`:

    gem 'paper_trail-audit'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install paper_trail-audit

## Usage
Consider a class defined as below
```ruby
class Bank < ActiveRecord::Base
  belongs_to :user
  has_paper_trail
  paper_trail_audit_for :value, :user
end
```

The `paper_trail_audit_for` command adds functions for querying changes on each of the specified attributes. `paper_trail_audit_for [:value,:user]` adds the functions `value_changes` and `user_changes`. If there are some changes made we can query the change log for a specific field

```ruby
b = Bank.create(value: 100)
b.update(value: 10)
b.update(user: some_user)
b.update(value: nil)
b.update(value: 40)

b.value_change
#[#<PaperTrailAudit::Change:0x007fbd359a1920 @old_value=nil, @new_value=100, @time=2016-08-03 02:39:16 UTC, @whodunnit=nil>,
##<PaperTrailAudit::Change:0x007fbd359a0fc0 @old_value=100, @new_value=10, @time=2016-08-03 02:39:16 UTC, @whodunnit=nil>,
##<PaperTrailAudit::Change:0x007fbd359a0688 @old_value=10, @new_value=nil, @time=2016-08-03 02:39:16 UTC, @whodunnit=nil>,
##<PaperTrailAudit::Change:0x007fbd35993a78 @old_value=nil, @new_value=40, @time=Wed, 03 Aug 2016 02:39:16 UTC +00:00, @whodunnit=nil>]
```
changes are reported as an array sorted in ascending chronological order. The objects are plain ruby objects with attributes, old_value, new_value, time, whodunnit. Which should be self explanatory

Values of belongs_to relations can be tracked and the values will be reported as the models and not the ids
```ruby
u1 = User.create
u2 = User.create
b = Bank.create(value: 100)
b.update(user: u1)
b.update(user: u2)
b.update(user: nil)

b.user_changes
#[#<PaperTrailAudit::Change:0x007fc824c6eff0
# => @old_value=nil,
# => @new_value=#<User id: 2, name: nil, created_at: "2016-08-03 02:43:34", updated_at: "2016-08-03 02:43:34">,
# => @time=2016-08-03 02:43:34 UTC,
# => @whodunnit=nil>,
#<PaperTrailAudit::Change:0x007fc824c6ed20
# => @old_value=#<User id: 2, name: nil, created_at: "2016-08-03 02:43:34", updated_at: "2016-08-03 02:43:34">,
# => @new_value=#<User id: 3, name: nil, created_at: "2016-08-03 02:43:34", updated_at: "2016-08-03 02:43:34">,
# => @time=2016-08-03 02:43:34 UTC,
# => @whodunnit=nil>,
#<PaperTrailAudit::Change:0x007fc824c6eb40
# => @old_value=#<User id: 3, name: nil, created_at: "2016-08-03 02:43:34", updated_at: "2016-08-03 02:43:34">,
# => @new_value=nil,
# => @time=Wed, 03 Aug 2016 02:43:34 UTC +00:00,
# => @whodunnit=nil>]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
