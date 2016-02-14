module ApplicationHelper

  # Na zadany text aplikuje Markdown.
  def apply_markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text)
  end

  # Na zadany text aplikuje Markdown a nasledne odstrani HTML znacky.
  def clear_markdown(text)
    strip_tags(apply_markdown(text))
  end

end
