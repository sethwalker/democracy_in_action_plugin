# DemocracyInAction
module DemocracyInAction
  class << self
    def configure
      yield config if block_given?
    end
    def config
      DemocracyInAction::Config.instance
    end
  end
end
