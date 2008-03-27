# DemocracyInAction
module DemocracyInAction
  class << self
    def configure
      yield self if block_given?
    end

    def auth
      DemocracyInAction::Auth
    end

    def mirroring
      DemocracyInAction::Mirroring
    end
  end
end
