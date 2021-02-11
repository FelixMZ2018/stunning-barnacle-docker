require "rails_helper"

RSpec.describe Api::V1::MessagesController, type: :controller do
  describe "All Messages can be retrieved using the index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(200) # be_successful expects a HTTP Status code of 200
    end
    it "returns the number of messages at 0" do
      get :index
      expect(JSON.parse(response.body)["messages"].count).to eq(0)
    end
  end

  describe "Create Messages " do
    context "when the request is valid" do
      it "creates a message" do
        post :create, params: { content: "This is a test message" }
        expect(JSON.parse(response.body)["message"]["content"]).to eq("This is a test message")
      end
      it "Increase the number of messages by 1" do
        post :create, params: { content: "This is a test message" }
        get :index
        expect(JSON.parse(response.body)["count"]).to eq(1)
      end
      it "Uses a UUIDv4 as identifier" do
        post :create, params: { content: "This is a test message" }
        expect(JSON.parse(response.body)["message"]["id"]).to match /[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/
      end
      it "Supports characters from different langauges" do
        post :create, params: { content: "古池や蛙飛び込む水の音" }
        expect(JSON.parse(response.body)["message"]["content"]).to eq("古池や蛙飛び込む水の音")
      end
    end
    context "When the request is invalid" do
      it "does not accept an empty message" do
        post :create, params: { content: "" }
        expect(response).to have_http_status(400) # be_successful expects a HTTP Status code of 200
      end
      it "Does not accept a message over 255 characters" do
        post :create,
             params: { content: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?" }
        expect(response).to have_http_status(400) # be_successful expects a HTTP Status code of 200
      end
      it "Does remove HTML Tags" do
        post :create, params: { content: "<script>console.log(false)</script>Real message" }
        expect(JSON.parse(response.body)["message"]["content"]).to_not eq("<script>console.log(false)</script>")
      end
      it "Retains HTML Link Tags" do
        post :create, params: { content: '<a href="https://www.w3schools.com">Visit W3Schools</a>' }
        expect(JSON.parse(response.body)["message"]["content"]).to eq('<a href="https://www.w3schools.com">Visit W3Schools</a>')
      end
    end
  end
  describe "Can access and update messages using the ID" do
    it "Can update a message given the UUID" do
      post :create, params: { content: "This is a test message" }
      id = JSON.parse(response.body)["message"]["id"]
      get :show, params: { id: id }
      put :update, params: { id: id, content: "This is a new message" }
      expect(JSON.parse(response.body)["message"]["content"]).to eq("This is a new message")
    end

	it "Increments message counter through read" do
	  post :create, params: { content: "This is a test message" }
	  id = JSON.parse(response.body)["message"]["id"]
	  original_counter = JSON.parse(response.body)["message"]["counter"]
	  get :show, params: { id: id }
      expect(JSON.parse(response.body)["message"]["counter"].to_i).to eq(original_counter.to_i + 1)
	end 

	it "Keeps validation rules for updates" do
	  post :create, params: { content: "This is a test message" }
      id = JSON.parse(response.body)["message"]["id"]
      get :show, params: { id: id }
      put :update, params: { id: id }
	  expect(response).to have_http_status(400) # be_successful expects a HTTP Status code of 200

	end
    it "Can delete a message given the UUID" do
      post :create, params: { content: "This is a test message" }
      id = JSON.parse(response.body)["message"]["id"]
      delete :destroy, params: { id: id }
      get :show, params: { id: id }
      expect(response).to have_http_status(404)
    end
  end
end
