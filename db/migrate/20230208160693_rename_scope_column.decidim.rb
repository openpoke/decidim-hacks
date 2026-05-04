# frozen_string_literal: true

# This migration comes from decidim (originally 20200326102407)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class RenameScopeColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :decidim_content_blocks, :scope, :scope_name
  end
end
