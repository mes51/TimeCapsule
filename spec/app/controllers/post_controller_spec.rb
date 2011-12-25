require 'spec_helper'

describe "PostController" do
  before do
    stub(Time).now { Time.new(2011, 12, 25, 12) }
  end

  after do
    Post.delete_all
  end

  let(:day) { 24 * 3600 }

  describe "post" do
    context "valid parms given" do
      let(:post_text) { "rwofowejfoewfoiwn" }
      let(:post_time) { 100 }

      before do
        post TimeCapsuleEnv["url"] + "post",
             { :post => post_text,
               :post_time => post_time },
             "rack.session" => { :user => User.new({ :user_id => "444420137",
                                                     :screen_name => "TimeMachineTest",
                                                     :access_key => "444420137-VcxV0606pltj3PCm2Xb0nBlOgfA0wtODzkldlf6N",
                                                     :access_key_secret => "hChTRh34NAr2JfX0V8sbpV9ojR0VJXAbMEoFrHQh9jE" }) }
      end

      context do
        subject { last_response.body }
        it { should == "complete" }
      end

      context do
        subject { Post.where.to_a.length }
        it { should_not == 0 }
      end

      context do
        subject { Post.where.to_a[0].post }
        it { should == post_text }
      end

      context do
        subject { Post.where.to_a[0].post_time }
        it { should == Time.now + post_time * day }
      end
    end

    context "no logged in" do

    end

    context "invalid params given" do
    end
  end
end
