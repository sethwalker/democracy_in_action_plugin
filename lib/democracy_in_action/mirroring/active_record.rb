module DemocracyInAction
  module Mirroring
    module ActiveRecord
      def self.after_save(model)
        democracy_in_action = model.democracy_in_action

        fields = democracy_in_action.defaults(model.attributes)

        fields.merge!(democracy_in_action.mappings(model))

        key = model.democracy_in_action_key
        fields['key'] = key if key

        model.democracy_in_action_key = DemocracyInAction::Mirroring.api.process democracy_in_action.table.name, fields

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
