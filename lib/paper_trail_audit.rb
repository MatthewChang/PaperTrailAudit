require "paper_trail_audit/version"
require "paper_trail_audit/change"

module PaperTrailAudit
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    def calculate_audit_for(param)
      #Gets all flattened attribute lists
      objects = [self.attributes,self.versions.map {|e| YAML.load(e.object) if e.object}.compact].flatten
      #rejecting objects with no update time, orders by the updated at times in ascending order
      objects = objects.select {|e| e["updated_at"]}.sort_by {|e| e["updated_at"]}
      result = []
      #Add the initial state if the first element has a value
      if(objects.count > 0 && !objects.first[param.to_s].nil?)
        result <<  PaperTrailAudit::Change.new({old_value: nil, new_value: objects.first[param.to_s], time: objects.first["updated_at"]})
      end
      objects.each_cons(2) do |a,b|
        if a[param.to_s] != b[param.to_s]
          result << PaperTrailAudit::Change.new({old_value: a[param.to_s], new_value: b[param.to_s], time: b["updated_at"]})
        end
      end
      result
    end

    module ClassMethods
      def paper_trail_audit_for(params)
        params.each do |param|
          if(self.column_names.include?(param.to_s))
            #Define a method which returns a list of audit change events
            define_method param.to_s+"_changes" do
              self.calculate_audit_for(param)
            end
          else
            reflection = self.reflect_on_all_associations(:belongs_to).select{|e| e.name == param}.first
            if(reflection)
              define_method param.to_s+"_changes" do
                self.calculate_audit_for(reflection.foreign_key).each do |o|
                  o.old_value = reflection.klass.find(o.old_value) if o.old_value
                  o.new_value = reflection.klass.find(o.new_value) if o.new_value
                end
              end
            else
              raise "Property \"#{param}\" does not exist on object #{self}"
            end
          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
    include PaperTrailAudit::Model
end
