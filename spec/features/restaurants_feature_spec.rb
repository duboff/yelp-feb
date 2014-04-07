require 'spec_helper'

describe 'the restaurants index page' do
  context 'no restaurants have been added' do
    it 'should display a warning message' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
    end

    describe 'adding a restaurant' do
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
    end
  end

  context 'with existing restaurants' do
    before do
      Restaurant.create({:name => 'McDonalds'})
    end

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
  end
end