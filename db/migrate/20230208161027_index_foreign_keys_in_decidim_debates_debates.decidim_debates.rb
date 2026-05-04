# frozen_string_literal: true

# This migration comes from decidim_debates (originally 20200320105918)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class IndexForeignKeysInDecidimDebatesDebates < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_debates_debates, :decidim_user_group_id
  end
end
