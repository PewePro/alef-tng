require 'rails_helper'

describe "Concepts Management", type: :request do

  it "should create new concept" do

    get admin_learning_objects_path
    expect(response).to redirect_to(new_user_session_path)

    # Prihlasenie ako administrator.
    user = FactoryGirl.create(:admin)
    post user_session_path, { local_user: { login: user.login, password: user.password } }

    course = FactoryGirl.create(:course)

    concept_count = Concept.all.count

    post admin_concepts_path(course: course), {
          concept: { name: 'konceptik', pseudo: "1" }
    }, { referer: admin_concepts_path(course: course) }

    expect(Concept.last.name).to eq('konceptik')
    expect(Concept.last.pseudo).to eq(true)

    post admin_concepts_path(course: course), {
        concept: { name: 'konceptisko', pseudo: "0" }
    }, { referer: admin_concepts_path(course: course) }

    expect(Concept.last.name).to eq('konceptisko')
    expect(Concept.last.pseudo).to eq(false)

    expect(concept_count).to eq(Concept.all.count - 2)

    expect(response).to redirect_to(admin_concepts_path(course: course))

  end

  it "should update concept" do

    get admin_learning_objects_path
    expect(response).to redirect_to(new_user_session_path)

    # Prihlasenie ako administrator.
    user = FactoryGirl.create(:admin)
    post user_session_path, { local_user: { login: user.login, password: user.password } }

    course = FactoryGirl.create(:course)

    post admin_concepts_path(course: course), {
        concept: { name: 'konceptik', pseudo: "1" }
    }, { referer: admin_concepts_path(course: course) }

    concept_id = Concept.last.id

    expect(Concept.last.name).to eq('konceptik')
    expect(Concept.last.pseudo).to eq(true)

    patch admin_concept_path(id: concept_id, course: course), {
        concept: { name: 'konceptisko', pseudo: "0" }
    }, { referer: admin_concepts_path(course: course) }

    expect(Concept.find(concept_id).name).to eq('konceptisko')
    expect(Concept.find(concept_id).pseudo).to eq(false)

    expect(Concept.all.count).to eq(1)

  end

end