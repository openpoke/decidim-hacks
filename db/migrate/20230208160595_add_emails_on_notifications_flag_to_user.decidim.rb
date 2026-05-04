# frozen_string_literal: true

# This migration comes from decidim (originally 20170912082054)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class AddEmailsOnNotificationsFlagToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_users, :email_on_notification, :boolean, default: false, null: false
  end
end
