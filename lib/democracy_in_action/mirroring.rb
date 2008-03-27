module DemocracyInAction
  class Mirroring
    class << self
      def method_missing(method, *args)
        if method.to_s =~ /\=$/
          mirror(method.to_s.chomp('='), args.first)
        end
      end
      def mirror(table, klass)
      end
    end
  end
end
