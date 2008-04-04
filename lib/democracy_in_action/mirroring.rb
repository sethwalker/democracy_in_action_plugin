require 'ostruct'
module DemocracyInAction
  class Mirroring

    class << self
      def method_missing(method, *args)
        # c.mirroring.supporter = User => mirror('supporter', User)
        if method.to_s =~ /\=$/
          mirror(method.to_s.chomp('='), args.first)
        end
      end

      # save to DemocracyInAction table with attributes of model
      def mirror(table, model)
        if block_given?
          configurator = OpenStruct.new
          yield configurator
        end
        model.__send__ :include, DemocracyInAction::Mirroring::ActiveRecord unless model.included_modules.include?(DemocracyInAction::Mirroring::ActiveRecord)
      end
    end

    module ActiveRecord

      def self.included(base)
        base.class_eval do
          after_save :update_democracy_in_action
        end
      end

      def update_democracy_in_action
        key = democracy_in_action_key
        api = DemocracyInAction::API.new
      end

      def democracy_in_action_key
        #denormalized ftw?
        if attributes.keys.include?(:democracy_in_action_key)
          read_attribute(:democracy_in_action_key)
        elsif respond_to?(:democracy_in_action_proxy)
          democracy_in_action_proxy.remote_key
        end
      end

    end
  end
end
