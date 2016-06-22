require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#index action" do
		it "should successfully show the page" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do
		it "should require users to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show the new form" do
			user = FactoryGirl.create(:user)
			sign_in user

			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do
		it "should require users to be logged in" do
			post :create, gram: { message: "Hello" }
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully create a new gram in our database" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, gram: {message: 'Hello!'}
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram.message).to eq("Hello!")
			expect(gram.user).to eq(user)
		end

		it "should properly deal with validation errors" do
			user = FactoryGirl.create(:user)
			sign_in user

			gram_count = Gram.count 
			post :create, gram: {message: ''}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(gram_count).to eq Gram.count
		end
	end

	describe "grams#show action" do
		it "should successfully show the page if the gram is found" do
			gram = FactoryGirl.create(:gram)
			get :show, id: gram.id
			expect(response).to have_http_status(:success)
		end

		it "should return 404 error if the gram is not found" do
			get :show, id:'TACOCAT'
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#edit action" do
		it "should successfully show the edit form if the gram is found" do
			editGram = FactoryGirl.create(:gram)
			get :edit, id: editGram.id
			expect(response).to have_http_status(:success)
		end

		it "should return a 404 error if the gram is not found" do
			get :edit, id: 'SILLYGOOSE'
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#update action" do
		it "should allow users to successfully update grams" do
			updateGram = FactoryGirl.create(:gram, message: "Initial Value")
			patch :update, id: updateGram.id, gram: {message: "Changed"}
			expect(response).to redirect_to root_path

			updateGram.reload
			expect(updateGram.message).to eq "Changed"
		end

		it "should return 404 error if the gram is not found" do
			patch :update, id: 'TRIXRABBIT', gram: {message: "Changed"}
			expect(response).to have_http_status(:not_found)
		end

		it "should render the edit form with return status unprocessable_entity" do
			updateGram = FactoryGirl.create(:gram, message: "Initial Value")
			patch :update, id: updateGram.id, gram: {message: ""}
			expect(response).to have_http_status(:unprocessable_entity)

			updateGram.reload
			expect(updateGram.message).to eq "Initial Value"
		end
	end

	describe "grams#delete action" do
		it "should allow user to destroy the gram" do
			deleteGram = FactoryGirl.create(:gram)
			delete :destroy, id: deleteGram.id
			expect(response).to redirect_to root_path

			deleted = Gram.find_by_id(deleteGram.id)
			expect(deleted).to eq nil
		end

		it "should return a 404 error cannot find the gram with the specified id" do
			delete :destroy, id: 'SPACEJAM'
			expect(response).to have_http_status(:not_found)
		end
	end
end
