# frozen_string_literal: true

# This migration comes from decidim (originally 20161110105712)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class CreateDecidimFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_features do |t|
      t.string :manifest_name
      t.jsonb :name
      t.references :decidim_participatory_process, index: true
    end
  end
end
