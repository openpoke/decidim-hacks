# frozen_string_literal: true

# This migration comes from decidim_surveys (originally 20200610090650)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-04 13:34:57 UTC
class RemoveSurveyAnswerOptions < ActiveRecord::Migration[5.2]
  def change
    drop_table :decidim_surveys_survey_answer_options, if_exists: true
  end
end
