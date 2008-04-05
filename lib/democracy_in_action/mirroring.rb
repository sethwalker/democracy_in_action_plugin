# note:
# possible to have a multiple mirrorings per class?  model.democracy_in_action[key].mappings
module DemocracyInAction
  module Mirroring

    def self.auth
      DemocracyInAction::Auth
    end

    def self.api
      @@api ||= DemocracyInAction::API.new 'authCodes' => [auth.username, auth.password, auth.org_key]
    end

    def self.mirror(table, model, &block)
      Mirror.new(table, model, &block)
    end

    class Mirror
      attr_reader :mappings, :table

      def initialize(table, model, &block)
        return if model.respond_to?(:democracy_in_action) && model.democracy_in_action#only one for now

        @mappings = {}

        raise 'no table given' if table.to_s.empty?
        @table = DemocracyInAction::Tables.const_get(table.to_s.gsub(/(^|_)(.)/) { $2.upcase }).new

        instance_eval(&block) if block_given?

        model.class_eval do
          require 'democracy_in_action/mirroring/active_record' #to avoid a warning
          include DemocracyInAction::Mirroring::ActiveRecord
          cattr_accessor :democracy_in_action
          after_save DemocracyInAction::Mirroring::ActiveRecord
          after_destroy DemocracyInAction::Mirroring::ActiveRecord
          has_one :democracy_in_action_proxy, :as => :local, :class_name => 'DemocracyInAction::Proxy', :dependent => :destroy
        end unless model.included_modules.include?(DemocracyInAction::Mirroring::ActiveRecord)
        model.democracy_in_action = self
      end

      # returns a hash of 'Democracy_In_Action_Column_Name' => value
      def mappings(model)
        return {} unless @mappings[table.name]
        @mappings[table.name].inject({}) do |fields, (field, map)|
          if map.is_a?(Proc)
            value = map.call(model)
            fields[field] = value if value
          else
            fields[field] = map
          end
          fields
        end
      end

      def map(column, value=nil, &block)
        @mappings[table.name] ||= {}
        @mappings[table.name][column] = block if block_given?
        @mappings[table.name][column] = value if value
        @mappings[table.name][column]
      end

      def defaults(attributes)
        attributes.inject({}) do |defaults, (key, value)|
          key = key.to_s.titleize.gsub(' ', '_')
          defaults[key] = value if table.columns.include?(key)
          defaults
        end
      end

    end
  end
end
