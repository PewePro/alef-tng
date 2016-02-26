class MarkdownController < ApplicationController

  # Aplikuje Markdown na text zadany ako vstup.
  def preview
    render html: apply_markdown(params[:text]).html_safe
  end

end