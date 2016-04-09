require 'rails_helper'

describe Admin::LearningObjectsController do

  describe "index" do

    # Prihlasenie administratora
    before do
      # Nasetupovanie kurzu.
      @course = FactoryGirl.create(:course)
      @setup = FactoryGirl.create(:setup, course: @course)
      @week = FactoryGirl.create(:week, setup: @setup)
      @concept = FactoryGirl.create(:concept, course: @course)

      @admin = FactoryGirl.create(:admin)

      # Prihlasenie administratora.
      visit root_path
      fill_in('local_user_login', with: @admin.login)
      fill_in('local_user_password', with: @admin.password)
      click_button(t('homescreen.links.login'))
    end

    it "should add feedback from admin" do

      visit administration_path

      FactoryGirl.create(:another_learning_object, course: @course)
      learning_object = FactoryGirl.create(:learning_object, course: @course)

      find("#learning-objects#{@course.id}").click

      click_link(learning_object.lo_id)

      #TODO: Nahradit prekladom.
      click_link("Spätná väzba")

      fill_in(t('activerecord.attributes.feedback.message'), with: 'blabla')
      click_button(t('admin.feedbacks.links.create'))

      # Teraz overime, ci sa komentar vytvoril.
      visit show_learning_object_path(id: learning_object, week_number: @week.number)

      # Klikneme na odpovedanie na otazku.
      find('#question-options-show button:first-child').click
      wait_for_ajax

      # A zistime, ci sa na stranke nachadza komentar.
      expect(page).to have_text('blabla')
      expect(page).to have_text(@admin.full_name)

    end

    it "should add anonymous teacher feedback from admin" do

      visit administration_path

      FactoryGirl.create(:another_learning_object, course: @course)
      learning_object = FactoryGirl.create(:learning_object, course: @course)

      find("#learning-objects#{@course.id}").click

      click_link(learning_object.lo_id)

      #TODO: Nahradit prekladom.
      click_link("Spätná väzba")

      fill_in(t('activerecord.attributes.feedback.message'), with: 'blabla')
      choose(t('feedbacks.labels.teacher'))
      click_button(t('admin.feedbacks.links.create'))

      # Teraz overime, ci sa komentar vytvoril.
      visit show_learning_object_path(id: learning_object, week_number: @week.number)

      # Klikneme na odpovedanie na otazku.
      find('#question-options-show button:first-child').click
      wait_for_ajax

      # A zistime, ci sa na stranke nachadza komentar.
      expect(page).to have_text('blabla')
      expect(page).to have_text(t('feedbacks.labels.teacher'))
      expect(page).not_to have_text(@admin.full_name)

    end

  end

end