# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20161025125300)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class AddPublishedAtToProcesses < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_participatory_processes, :published_at, :datetime, index: true
  end
end
