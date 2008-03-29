module DemocracyInAction
  class Mirroring
    class << self
      def method_missing(method, *args)
        if method.to_s =~ /\=$/
          mirror(method.to_s.chomp('='), args.first)
        end
      end
      def mirror(table, klass)
        klass.__send__ :after_save, DemocracyInAction::Mirroring::ActiveRecord
      end
    end
    module ActiveRecord
      def self.after_save(model)
        api = DemocracyInAction::API.new
      end
    end
  end
end
