require "paper_trail-audit/version"
require "paper_trail-audit/change"

module PaperTrailAudit
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    # Returns the audit list for the specified column
    #
    # @param [symbol] param: symbol to query
    # @return [array of Change objects]
    def calculate_audit_for(param)
      #Gets all flattened attribute lists
      #objects are a hash of
      #{attributes: object attributes, whodunnit: paper_trail whodunnit which caused the object to be in this state}
      objects = [{attributes: self.attributes, whodunnit: self.paper_trail.originator},
        self.versions.map {|e| {attributes: YAML.load(e.object), whodunnit: e.paper_trail_originator} if e.object}.compact].flatten
      #rejecting objects with no update time, orders by the updated at times in ascending order
      objects = objects.select {|e| e[:attributes]["updated_at"]}.sort_by {|e| e[:attributes]["updated_at"]}
      result = []
      #Add the initial state if the first element has a value
      if(objects.count > 0 && !objects.first[:attributes][param.to_s].nil?)
        result <<  PaperTrailAudit::Change.new({old_value: nil,
            new_value: objects.first[:attributes][param.to_s],
            time: objects.first[:attributes]["updated_at"],
            whodunnit: objects.first[:whodunnit]
            })
      end
      objects.each_cons(2) do |a,b|
        if a[:attributes][param.to_s] != b[:attributes][param.to_s]
          result << PaperTrailAudit::Change.new({old_value: a[:attributes][param.to_s],
            new_value: b[:attributes][param.to_s],
            time: b[:attributes]["updated_at"],
            whodunnit: b[:whodunnit]
          })
        end
      end
      result
    end

    module ClassMethods
      # Defines the functions which perform the audit generation
      #
      # Note: instead of looking at the type and performing a transformation
      # we could simply reify the versions and make the function calls, however
      # this causes a pretty significant performance hit, on an object with 100 versions
      # the reify version was about 4x slower, although with low version counts the
      # slowdown was much smaller, something like 1.06
      #
      # @param [array of params to audit] *params describe *params
      def paper_trail_audit_for(*params)
        #return warn("PaperTrailAudit WARNING: No table exists for #{self}") if self.connection.tables.empty?
        params = params.flatten
        params.each do |param|
          reflection = self.reflect_on_all_associations(:belongs_to).select{|e| e.name == param}.first
          if(reflection)
            define_method param.to_s+"_changes" do
              self.calculate_audit_for(reflection.foreign_key).each do |o|
                o.old_value = reflection.klass.find(o.old_value) if o.old_value
                o.new_value = reflection.klass.find(o.new_value) if o.new_value
              end
            end
            next
          end

          if self.defined_enums.include?(param.to_s)
            #if it's an enum, wrap the values to the enum keys
            define_method param.to_s+"_changes" do
              self.calculate_audit_for(param).each do |o|
                o.old_value = self.defined_enums[param.to_s].key(o.old_value)
                o.new_value = self.defined_enums[param.to_s].key(o.new_value)
              end
            end
          else
            #Define a method which returns a list of audit change events
            define_method param.to_s+"_changes" do
              self.calculate_audit_for(param)
            end
          end
        end
      end
    end
  end
end

class ActiveRecord::Base
    include PaperTrailAudit::Model
end
