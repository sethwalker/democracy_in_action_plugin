module DemocracyInAction
  class Proxy < ActiveRecord::Base
    set_table_name :democracy_in_action_proxies
    belongs_to :local, :polymorphic => true
  end
end
