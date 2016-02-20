describe 'Users::SessionsController' do

  describe "login" do
    before do
      @user = FactoryGirl.create(:user)
    end

    # Pokusi sa prihlasit ako standardny pouzivatel.
    it "should login user" do

      visit root_path
      fill_in('local_user_login', with: @user.login)
      fill_in('local_user_password', with: @user.password)

      click_button('Prihlásiť')

    end

  end

end