require 'rails_helper'

describe "Learning Objects Management", type: :request do

  it "should allow access for admins" do

    get admin_learning_objects_path
    expect(response).to redirect_to(new_user_session_path)

    # Prihlasenie ako administrator.
    user = FactoryGirl.create(:admin)
    post user_session_path, { local_user: { login: user.login, password: user.password } }

    course = FactoryGirl.create(:course)
    get admin_learning_objects_path(course: course.id)
    expect(response).to render_template(:index)

    get new_admin_learning_object_path(course: course.id)
    expect(response).to render_template(:new)

  end

  it "should not allow access for non-admins" do

    get admin_learning_objects_path
    expect(response).to redirect_to(new_user_session_path)

    # Prihlasenie ako bezny smrtelnik.
    user = FactoryGirl.create(:user)
    post user_session_path, { local_user: { login: user.login, password: user.password } }

    course = FactoryGirl.create(:course)
    get admin_learning_objects_path(course: course.id)
    expect(response).to redirect_to(new_user_session_path)

    get new_admin_learning_object_path(course: course.id)
    expect(response).to redirect_to(new_user_session_path)

  end

end