# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20170129153716)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class RemoveShortDescriptionFromMeetings < ActiveRecord::Migration[5.0]
  def change
    remove_column :decidim_meetings_meetings, :short_description
  end
end
