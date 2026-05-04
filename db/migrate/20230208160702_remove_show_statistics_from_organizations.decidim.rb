# frozen_string_literal: true

# This migration comes from decidim (originally 20200929171508)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class RemoveShowStatisticsFromOrganizations < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_organizations, :show_statistics
  end
end
