# frozen_string_literal: true

# This migration comes from decidim (originally 20180808135006)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class AddImagesToContentBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_content_blocks, :images, :jsonb, default: {}
  end
end
