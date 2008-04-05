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
      def mirror(table, model, &block)
        if block_given?
          configurator = OpenStruct.new
          configurator.instance_eval do
            def map(field, &block)
              self.send "#{field}=", block
            end
          end
          configurator.instance_eval(&block)
        end
        model.__send__ :include, DemocracyInAction::Mirroring::ActiveRecord unless model.included_modules.include?(DemocracyInAction::Mirroring::ActiveRecord)
        model.democracy_in_action_remote_table = table
      end
    end

    module ActiveRecord

      def self.included(base)
        base.class_eval do
          cattr_accessor :democracy_in_action_remote_table
          after_save :update_democracy_in_action
          has_one :democracy_in_action_proxy, :as => :local, :class_name => 'DemocracyInAction::Proxy'
          
        end
      end

      def self.map_defaults(attributes)
        attributes.inject({}) do |defaults, (key, value)|
          key = key.to_s.titleize.gsub(' ', '_')
          defaults[key] = value if key == 'First_Name'
          defaults
        end
      end

      def self.democracy_in_action_api
        auth = DemocracyInAction::Auth
        DemocracyInAction::API.new 'authCodes' => [auth.username, auth.password, auth.org_key]
      end


      # instance methods added to model:
      def update_democracy_in_action
        key = democracy_in_action_key

        fields = map_defaults(attributes)

        self.democracy_in_action_key = democracy_in_action_api.process democracy_in_action_remote_table, fields

#        api.describe 'supporter'
#        self.democracy_in_action_key = api.process
      end

      def democracy_in_action_key
        #denormalized ftw?
        if attributes.keys.include?(:democracy_in_action_key)
          read_attribute(:democracy_in_action_key)
        elsif respond_to?(:democracy_in_action_proxy) && democracy_in_action_proxy
          democracy_in_action_proxy.remote_key
        end
      end

      def democracy_in_action_key=(key)
        if attributes.keys.include?(:democracy_in_action_key)
          write_attribute(:democracy_in_action_key, key)
        elsif respond_to?(:democracy_in_action_proxy)
          if democracy_in_action_proxy
            democracy_in_action_proxy.update_attribute(:remote_key, key)
          else
            create_democracy_in_action_proxy(:remote_key => key, :remote_table => 'what?')
          end
        else
          raise "can't save DemocracyInAction key"
        end
      end
    end
  end
end
