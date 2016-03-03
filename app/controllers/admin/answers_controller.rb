module Admin
  # Umoznuje spravovat odpovede na otazky.
  class AnswersController < ApplicationController

    before_filter :get_learning_object

    #TODO: Pridat autorizaciu cez cancan.
    #authorize_resource :class => false

    # Vytvori novu odpoved na vzdelavaci objekt.
    def create
      begin
        ActiveRecord::Base.transaction do
          @learning_object.answers.create!({
                             answer_text: params[:answer][:answer_text],
                             is_correct: params[:answer][:is_correct] == "1",
                             visible: params[:answer][:visible_answer] == "1"
                         })
          @learning_object.validate_answers!
        end
      rescue AnswersCorrectnessError
        return redirect_to(edit_question_config_path, :alert => "Otázka nesmie mať viac ako jednu správnu odpoveď.")
      rescue AnswersVisibilityError
        return redirect_to(edit_question_config_path, :alert => "Otázka nesmie mať viac ako jednu viditeľnú odpoveď.")
      end

      redirect_to edit_admin_learning_object_path(id: @learning_object.id, anchor: 'answer-settings'), :notice => "Odpoveď bola pridaná."
    end

    # Ulozi zmeny v odpovediach na otazky.
    def update
      route = edit_admin_learning_object_path(id: @learning_object.id, anchor: 'answer-settings')

      begin
        ActiveRecord::Base.transaction do
          @learning_object.answers.force_all.each do |a|
            a.update!(
                is_correct: params["correct_answer_#{a.id}"] == "1",
                visible: params["visible_answer_#{a.id}"] == "1",
                answer_text: params["edit_answer_text_#{a.id}"]
            )
          end
          @learning_object.validate_answers!
        end
      rescue AnswersCorrectnessError
        return redirect_to(route, :alert => "Otázka nesmie mať viac ako jednu správnu odpoveď.")
      rescue AnswersVisibilityError
        return redirect_to(route, :alert => "Otázka nesmie mať viac ako jednu viditeľnú odpoveď.")
      end

      redirect_to route, :notice => "Zmeny v odpovediach boli úspešne uložené."
    end

    # Odstrani odpoved na vzdelavaci objekt.
    def destroy
      Answer.force_all.find_by_id(params[:answer_id]).destroy!
      redirect_to edit_admin_learning_object_path(id: @learning_object.id, anchor: 'answer-settings'), :notice => "Odpoveď bola odstránená."
    end

    private
    def get_learning_object
      begin
        @learning_object = LearningObject.find(params[:learning_object_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to administration_path
      end
    end

  end
end