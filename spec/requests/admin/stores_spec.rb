require 'spec_helper'


describe "Administrator store pages" do
  let!(:admin_user) { FactoryGirl.create(:user, :admin => true) }
  let!(:test_two_store) { FactoryGirl.create(:store, :owner_id => admin_user.id) }

  before(:each) do
    test_two_store.add_admin(admin_user)
    visit "/sessions/new"
    fill_in "email", with: admin_user.email
    fill_in "password", with: "foobar"
    click_link_or_button("Log in")
  end

  context "admin visits admin page page for store" do
    before (:each) do
      visit admin_dashboard_url(:subdomain => test_two_store.url_name)
    end

    it "has an edit link that takes you to the edit page" do
      page.should have_content('Edit Store Details')
    end

    context "editing store details" do
      before(:each) do
        click_link_or_button('Edit Store Details')
      end

      it "takes you to the edit page when you click the edit store link" do
        page.should have_selector('#edit')
      end

      describe "changing the name" do

        it "allows you to edit the name" do
          new_name = Faker::Internet.name
          fill_in "store_name", with: new_name
          click_link_or_button('Update Store')
          page.should have_content(new_name)
        end

        it "gives a flash message when you edit the name" do
          new_name = Faker::Internet.user_name
          fill_in "store_name", with: new_name
          click_link_or_button('Update Store')
          page.should have_selector('#alert')
          page.should have_content('was updated!')
        end

        it "does not find the old store name" do
          old_name = test_two_store.name
          new_name = Faker::Internet.user_name
          fill_in "store_name", with: new_name
          click_link_or_button('Update Store')
          page.should_not have_content old_name
        end
      end

      describe "changing the url_name" do

        it "includes the url_name form" do
          page.should have_selector("#edit_url")
        end

        it "asks for confirmation" do
          pending "Can probably drop this test - for Javascript"
        end

      end
    end
  end
end