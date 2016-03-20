require 'rails_helper'

describe 'Users::SessionsController' do

  describe "login" do
    before do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:admin)
      FactoryGirl.create(:setup, course: FactoryGirl.create(:course))
    end

    # Pokusi sa prihlasit ako standardny pouzivatel.
    it "should login user" do

      visit root_path
      fill_in('local_user_login', with: @user.login)
      fill_in('local_user_password', with: @user.password)

      click_button(t('homescreen.links.login'))

    end

    # Pokusi sa prihlasit ako administrator.
    it "should allow admin access for administrator" do

      visit root_path
      fill_in('local_user_login', with: @admin.login)
      fill_in('local_user_password', with: @admin.password)

      click_button(t('homescreen.links.login'))

      find('.user-element-cta').click

      find('a', text: t('homescreen.links.admin')).click

      expect(page).to have_text(t('homescreen.links.admin'))

    end

    # Pokusi sa prihlasit ako standardny pouzivatel.
    it "should not allow student access to admin" do

      visit root_path
      fill_in('local_user_login', with: @user.login)
      fill_in('local_user_password', with: @user.password)

      click_button(t('homescreen.links.login'))

      find('.user-element-cta').click
      expect(page).not_to have_text(t('homescreen.links.admin'))

      visit administration_path

    end

  end

end