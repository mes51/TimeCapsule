require 'spec_helper'

describe "UserController" do
  let(:user) { User.new({ :user_id => "444420137",
                        :screen_name => "TimeMachineTest",
                        :access_key => "444420137-VcxV0606pltj3PCm2Xb0nBlOgfA0wtODzkldlf6N",
                        :access_key_secret => "hChTRh34NAr2JfX0V8sbpV9ojR0VJXAbMEoFrHQh9jE" }) }

  describe "get_info" do
    let(:parser) { Yajl::Parser.new(:symbolize_keys => true) }

    context "not login" do
      before do
        get "/user/get_info"
      end

      subject { parser.parse(last_response.body)[:logged_in] }
      it { should be_false }
    end

    context "logged in" do

      before do
        get "/user/get_info", { }, "rack.session" => { "user" => user }
      end

      subject { parser.parse(last_response.body)[:logged_in] }
      it { should be_true }
    end
  end

  describe "logout" do
    before do
      get "user/logout", { }, "rack.session" => { "user" => user }
    end

    subject { last_request.env["rack.session"].to_hash["user"] }
    it { should be_nil }
  end
end
