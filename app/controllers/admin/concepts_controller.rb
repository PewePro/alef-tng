module Admin
  # Umoznuje spravovat koncepty.
  class ConceptsController < BaseController

    before_filter :get_course

    # Vykresli zoznam vsetkych konceptov spolu s moznostou ich upravovat.
    def index
      @concepts = @course.concepts.order('name ASC')
      @concepts_counts = ConceptsLearningObject.where(concept_id: @concepts.pluck(:id)).group('concept_id').count
    end

    def create
      @course.concepts.create!(parse_params)
      redirect_to :back
    end

    # Ulozi hromadne zmeny vo viacerych konceptoch.
    def update
      Concept.find(params[:id]).update!(parse_params)
      render nothing: true
    end

    def destroy
      Concept.find(params[:id])#.destroy!
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