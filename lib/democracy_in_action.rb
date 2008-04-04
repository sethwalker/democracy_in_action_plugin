require File.join(File.dirname(__FILE__), '..', 'vendor', 'democracy_in_action', 'lib', 'democracyinaction.rb')

module DemocracyInAction
  class << self
    def configure
      yield self if block_given?
    end

    def auth
      DemocracyInAction::Auth
    end

    #c.mirroring.supporter = User
    #c.mirroring(:groups, Group) {|g| g.parent_KEY = 1234}
    #mirror is an alias for mirroring
    def mirroring(table=nil, model=nil)
      if table && model
        if block_given?
          DemocracyInAction::Mirroring.mirror(table, model) {|*block_args| yield(*block_args) }
        else
          DemocracyInAction::Mirroring.mirror(table, model)
        end
      else
        DemocracyInAction::Mirroring
      end
    end
    alias :mirror :mirroring
  end
end
