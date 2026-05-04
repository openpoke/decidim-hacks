# frozen_string_literal: true

# This migration comes from decidim_surveys (originally 20200610090725)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class RemoveSurveyAnswers < ActiveRecord::Migration[5.2]
  def change
    drop_table :decidim_surveys_survey_answers, if_exists: true
  end
end
