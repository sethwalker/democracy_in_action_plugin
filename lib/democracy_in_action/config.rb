module DemocracyInAction
  class Config
    include Singleton

    attr_accessor :nodes

    def initialize
      @nodes = {}
    end

    def method_missing(method, *args)
      (class << self; self; end).class_eval do
        define_method method do |*args|
          return nodes[method] ||= Node.new(method)
        end
      end
      __send__ method, *args
    end

    class Node
      attr_reader :node_name
      def initialize(name)
        @node_name = name
        @data = {}
      end
      def method_missing(method, *args)
        if method.to_s =~ /\=$/
          key = method.to_s.chomp('=').to_sym
          @data[key] = args.first
        else
          @data[method]
        end
      end
    end
  end
end
