# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20161110092735)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class AddIndexForProcessSlugOrganization < ActiveRecord::Migration[5.0]
  def change
    add_index :decidim_participatory_processes,
              [:decidim_organization_id, :slug],
              unique: true,
              name: "index_unique_process_slug_and_organization"
  end
end
