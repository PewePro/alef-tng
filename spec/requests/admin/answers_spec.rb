require 'rails_helper'

describe "Answers Management", type: :request do

  it "should create answer for learning object" do

    get admin_learning_objects_path
    expect(response).to redirect_to(new_user_session_path)

    # Prihlasenie ako administrator.
    user = FactoryGirl.create(:admin)
    post user_session_path, { local_user: { login: user.login, password: user.password } }

    learning_object = FactoryGirl.create(:learning_object, course: FactoryGirl.create(:course))
    post admin_learning_object_answers_path(learning_object_id: learning_object.id), {
        answer: { answer_text: 'test', is_correct: "0", visible_answer: "1" }
    }

    expect(response).to redirect_to(edit_admin_learning_object_path(id: learning_object.id, anchor: 'answer-settings'))

    expect(Answer.last.answer_text).to eq('test')
    expect(Answer.last.is_correct).to eq(false)
    expect(Answer.last.visible).to eq(true)

  end

  it "should not allow creating answers for non-admins" do

    get admin_learning_objects_path
    expect(response).to redirect_to(new_user_session_path)

    # Prihlasenie ako bezny smrtelnik.
    user = FactoryGirl.create(:user)
    post user_session_path, { local_user: { login: user.login, password: user.password } }

    learning_object = FactoryGirl.create(:learning_object, course: FactoryGirl.create(:course))
    post admin_learning_object_answers_path(learning_object_id: learning_object.id), {
        answer: { answer_text: 'test', is_correct: "1", visible_answer: "0" }
    }

    expect(response).to redirect_to(new_user_session_path)

  end

end