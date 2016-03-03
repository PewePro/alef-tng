require 'rails_helper'

describe Admin::LearningObjectsController do

  describe "index" do

    # Prihlasenie administratora
    before do
      @course = Course.create(name: 'Ultrauzasny predmet')
      @setup = Setup.create(course: @course, name: 'Ultrauzasny predmet')
      @admin = FactoryGirl.create(:admin)

      visit root_path
      fill_in('local_user_login', with: @admin.login)
      fill_in('local_user_password', with: @admin.password)
      click_button(t('homescreen.links.login'))

    end

    it "should create simple question" do

      visit administration_path

      find("#learning-objects#{@course.id}").click

      click_link("+ #{t('admin.questions.links.create')}")

      learning_object = FactoryGirl.create(:learning_object)

      # Vyplnenie vzdelavacieho objektu.
      fill_in(t('activerecord.attributes.learning_object.lo_id'), with: learning_object.lo_id)
      fill_in(t('activerecord.attributes.learning_object.question_text'), with: learning_object.question_text)
      select(t('admin.questions.labels.types.singlechoicequestion'), from: t('activerecord.attributes.learning_object.type'))

      click_button(t('global.links.save_changes'))

      # Overime, ci sa vzdelavaci objekt vytvoril.
      visit admin_learning_objects_path(course: @course.id)
      expect(page).to have_text(learning_object.lo_id)

      click_link(learning_object.lo_id)

      expect(page).to have_text(t('admin.questions.labels.types.singlechoicequestion'))

    end

    it "should edit simple question" do

      visit administration_path

      find("#learning-objects#{@course.id}").click

      click_link("+ #{t('admin.questions.links.create')}")

      learning_object = FactoryGirl.create(:learning_object)
      another_learning_object = FactoryGirl.create(:another_learning_object)

      # Vyplnenie vzdelavacieho objektu.
      fill_in(t('activerecord.attributes.learning_object.lo_id'), with: learning_object.lo_id)
      fill_in(t('activerecord.attributes.learning_object.question_text'), with: learning_object.question_text)
      select(t('admin.questions.labels.types.singlechoicequestion'), from: t('activerecord.attributes.learning_object.type'))

      click_button(t('global.links.save_changes'))

      expect(page).to have_text(learning_object.lo_id)

      fill_in(t('activerecord.attributes.learning_object.lo_id'), with: another_learning_object.lo_id)
      fill_in(t('activerecord.attributes.learning_object.question_text'), with: another_learning_object.question_text)
      select(t('admin.questions.labels.difficulties.impossible'), from: t('activerecord.attributes.learning_object.difficulty'))

      click_button(t('global.links.save_changes'))

      #TODO: Opravit link.
      #click_link('&raquo; späť na zoznam otázok')

      visit administration_path
      find("#learning-objects#{@course.id}").click

      # Overime, ci sa vzdelavaci objekt upravil.
      expect(page).to have_text(another_learning_object.lo_id)
      expect(page).to have_text(another_learning_object.question_text)

    end

  end

end