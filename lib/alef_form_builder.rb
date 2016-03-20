# Generator formularov pre Alef.
class AlefFormBuilder < ActionView::Helpers::FormBuilder
  # Vykresli chyby pre dany formularovy prvok.
  #
  # @param element [String] id elementu (spravidla zhodne s atributom v modeli)
  def errors(element)
    # Vykreslenie chyb.
    errors_msgs = ''
    if @object.errors.present?
      errors_msgs = @object.errors.full_messages_for(element).map do |error|
        @template.content_tag :li, error
      end.join
    end

    @template.content_tag :div, @template.content_tag(:ul, errors_msgs.html_safe), :class => 'form-control-errors',
                          :style => "#{'display: none' if errors_msgs.empty?}"
  end
end