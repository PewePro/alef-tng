require 'rails_helper'

describe 'Users::SessionsController' do

  describe "login" do
    before do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:admin)
      @setup = Setup.create(course: Course.create)
    end

    # Pokusi sa prihlasit ako standardny pouzivatel.
    it "should login user" do

      visit root_path
      fill_in('local_user_login', with: @user.login)
      fill_in('local_user_password', with: @user.password)

      click_button('Prihlásiť')

    end

    # Pokusi sa prihlasit ako administrator.
    it "should allow admin access for administrator" do

      visit root_path
      fill_in('local_user_login', with: @admin.login)
      fill_in('local_user_password', with: @admin.password)

      click_button('Prihlásiť')

      find('.user-element-cta').click

      find('a', text: 'Administrácia').click

      expect(page).to have_text('Administrácia')

    end

    # Pokusi sa prihlasit ako standardny pouzivatel.
    it "should not allow student access to admin" do

      visit root_path
      fill_in('local_user_login', with: @user.login)
      fill_in('local_user_password', with: @user.password)

      click_button('Prihlásiť')

      find('.user-element-cta').click
      expect(page).not_to have_text("Administrácia")

      visit administration_path

    end

  end

end