# frozen_string_literal: true

# This migration comes from decidim_assemblies (originally 20210907120249)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:56 UTC
class RemoveDesignationModeFromAssemblyMembers < ActiveRecord::Migration[6.0]
  def change
    remove_column :decidim_assembly_members, :designation_mode, :string
  end
end
