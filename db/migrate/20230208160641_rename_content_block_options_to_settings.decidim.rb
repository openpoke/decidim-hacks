# frozen_string_literal: true

# This migration comes from decidim (originally 20180802132147)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class RenameContentBlockOptionsToSettings < ActiveRecord::Migration[5.2]
  def change
    rename_column :decidim_content_blocks, :options, :settings
  end
end
