# frozen_string_literal: true

# This migration comes from decidim (originally 20170405091801)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class ChangeDecidimUserEmailIndexUniqueness < ActiveRecord::Migration[5.0]
  def change
    remove_index :decidim_users, :email
    add_index :decidim_users, [:email, :decidim_organization_id], unique: true
  end
end
