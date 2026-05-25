# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20201030133444)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class AddPromotedFlagToDecidimParticipatoryProcessGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_participatory_process_groups, :promoted, :boolean, default: false, index: true
  end
end
