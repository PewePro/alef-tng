module Admin
  # Umoznuje spravovat koncepty.
  class ConceptsController < BaseController

    before_filter :get_course, except: [:destroy, :learning_objects, :delete_learning_object]

    # Vykresli zoznam vsetkych konceptov spolu s moznostou ich upravovat.
    def index
      @concepts = @course.concepts.order('name ASC')
      @concepts_counts = ConceptsLearningObject.where(concept_id: @concepts.pluck(:id)).group('concept_id').count
    end

    # Vytvori novy koncept.
    def create
      @course.concepts.create!(parse_params)
      flash[:notice] = t('admin.concepts.texts.create_success')
      redirect_to :back
    end

    # Aktualizuje informacie o koncepte.
    def update
      Concept.find(params[:id]).update!(parse_params)
      render nothing: true
    end

    # Odstrani koncept.
    def destroy
      Concept.find(params[:id]).destroy!
      render nothing: true
    end

    # Nacita vsetky vzdelavacie objekty pridruzene k danemu konceptu.
    def learning_objects
      render json: ConceptsLearningObject.where(concept_id: params[:concept_id])
                       .eager_load(:learning_object)
                       .pluck('concepts_learning_objects.id, learning_objects.id, learning_objects.lo_id')
                       .map { |learning_object| { id: learning_object[0], lo_id: learning_object[1], name: learning_object[2] } }
    end

    # Odstrani priradenie vzdelavacieho objektu do konceptu.
    def delete_learning_object
      ConceptsLearningObject.find(params[:learning_object_id]).destroy!
      render nothing: true
    end

    private
    def parse_params
      concept_params = params.key?(:concept) ? params[:concept].permit(:name, :pseudo) : params.permit(:name, :pseudo)
      concept_params[:pseudo] = concept_params[:pseudo] == "1"
      concept_params
    end

    def get_course
      begin
        @course = Course.find(params[:course])
      rescue ActiveRecord::RecordNotFound
        redirect_to administration_path
      end
    end

  end
end