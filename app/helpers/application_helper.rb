module ApplicationHelper
  def fancy_words
    words = (1..4).map do |number|
      I18n.t("hacker_words.word#{number}")
    end
    words.join(",")
  end
end
