# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20210415163339)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class AllowNullFileColumnInDecidimAttachmentsTable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :decidim_attachments, :file, true
  end
end
