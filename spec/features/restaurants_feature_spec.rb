require 'spec_helper'

describe 'the restaurants index page' do
  context 'no restaurants have been added' do
    it 'should display a warning message' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
    end

    describe 'adding a restaurant' do

      context 'logged out' do
        it 'takes me to the sign in page' do
          visit '/restaurants'
          click_link 'Add a restaurant' 

          expect(current_path).to eq '/users/sign_in'
          expect(page).to have_content 'sign in'
        end
      end

      context 'logged in' do
        before do
          login_as_test_user
        end

        it 'should be listed on the index' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'McDonalds'
          fill_in 'Category', with: 'Fast food'
          fill_in 'Location', with: 'Everywhere'
          click_button 'Create Restaurant'

          expect(current_path).to eq '/restaurants'
          expect(page).to have_content 'McDonalds'
        end

        it 'should display errors if bad data is given' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          click_button 'Create Restaurant'

          expect(page).to have_content 'error'
        end
      end
    end
  end

  context 'with existing restaurants' do
    let!(:restaurant) { Restaurant.create(name: 'McDonalds') }

    describe 'editing a restaurant' do
      it 'should update the restaurant details' do
        visit '/restaurants'
        click_link 'Edit'
        fill_in 'Name', with: 'Old McDonalds'
        click_button 'Update Restaurant'

        expect(page).to have_content 'Old McDonalds'
      end
    end

    describe 'deleting a restaurant' do
      it 'should permenantly destroy the restaurant record' do
        visit '/restaurants'
        click_link 'Delete McDonalds'

        expect(page).not_to have_content 'McDonalds'
        expect(page).to have_content 'Restaurant deleted successfully!'
      end
    end

    context 'with reviews posted' do
      before do
        restaurant.reviews.create(rating: 3, comment: 'Food was OK')
      end

      describe 'the individual restaurant page' do
        it 'displays the review' do
          visit '/restaurants'
          click_link 'McDonalds'
          expect(page).to have_content 'Food was OK'
        end
      end
    end
  end
end