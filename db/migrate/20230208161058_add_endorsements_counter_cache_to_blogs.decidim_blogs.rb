# frozen_string_literal: true

# This migration comes from decidim_blogs (originally 20200128094730)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class AddEndorsementsCounterCacheToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_blogs_posts, :endorsements_count, :integer, null: false, default: 0
  end
end
