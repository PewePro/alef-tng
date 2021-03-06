require 'rails_helper'

describe Admin::ConceptsController do

  describe "index" do

    # Prihlasenie administratora
    before do
      # Nasetupovanie kurzu.
      @course = FactoryGirl.create(:course)
      @setup = FactoryGirl.create(:setup, course: @course)
      @week = FactoryGirl.create(:week, setup: @setup)

      @admin = FactoryGirl.create(:admin)

      # Prihlasenie administratora.
      visit root_path
      fill_in('local_user_login', with: @admin.login)
      fill_in('local_user_password', with: @admin.password)
      click_button(t('homescreen.links.login'))
    end

    it "should create and delete new concept" do

      visit admin_concepts_path(course: @course)

      # Vytvorenie konceptu.
      fill_in 'concept_name', with: 'epos o gilgamesovi'

      click_button t('admin.concepts.links.create_concept')

      expect(Concept.all.count).to eq(1)
      expect(Concept.last.name).to eq('epos o gilgamesovi')

      expect(page).to have_xpath("//input[@value='epos o gilgamesovi']")

      # Odstranenie konceptu.
      within("#concept#{Concept.last.id}") do
        find('.btn-delete').click
      end

      page.accept_confirm

      wait_for_ajax

      expect(Concept.all.count).to eq(0)
      expect(page).to_not have_xpath("//input[@value='epos o gilgamesovi']")

    end

    it "should create and assign new concept" do

      visit admin_concepts_path(course: @course)

      # Vytvorenie konceptu.
      fill_in 'concept_name', with: 'daidalos a ikaros'

      click_button t('admin.concepts.links.create_concept')

      expect(Concept.all.count).to eq(1)
      expect(Concept.last.name).to eq('daidalos a ikaros')

      # Tu este zapneme koncept pre prvy tyzden.
      visit administration_path

      find("#setup#{Concept.last.id}").click

      # Hladame potrebny checkbox
      within('#concepts-form') do
        find("#relations_#{Concept.last.id}_#{@week.id}").set(true)
        click_button t('global.links.save_changes')
      end

    end

  end

end