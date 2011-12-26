require 'spec_helper'

describe "PostController" do
  before do
    stub(Time).now { Time.new(2011, 12, 25, 12) }
  end

  after do
    Post.delete_all
  end

  let(:day) { 24 * 3600 }
  let(:post_text) { "rwofowejfoewfoiwn" }
  let(:post_time) { 100 }
  #FIXME: change your account access key and access key secret
  let(:user) { User.new({ :user_id => "444420137",
                          :screen_name => "TimeMachineTest",
                          :access_key => "444420137-VcxV0606pltj3PCm2Xb0nBlOgfA0wtODzkldlf6N",
                          :access_key_secret => "hChTRh34NAr2JfX0V8sbpV9ojR0VJXAbMEoFrHQh9jE" }) }

  describe "post" do
    context "valid parms given" do
      before do
        post TimeCapsuleEnv["url"] + "post",
             { :post => post_text,
               :post_time => post_time },
             "rack.session" => { :user => user }
      end

      context do
        subject { last_response.status }
        it { should == 200 }
      end

      context do
        subject { Post.where.to_a.length }
        it { should_not == 0 }
      end

      context do
        subject { Post.where.to_a[0].post }
        it { should == post_text }
      end

      let(:valid_post_time) { Time.new(Time.now.year, Time.now.month, Time.now.day) + post_time * day }
      context do
        subject { Post.where.to_a[0].post_time }
        it { should == valid_post_time }
      end
    end

    context "no logged in" do
      before do
        post TimeCapsuleEnv["url"] + "post",
             { :post => post_text,
               :post_time => post_time }
      end

      subject { last_response.status }
      it { should == 403 }
    end

    context "not give post text" do
      before do
        post TimeCapsuleEnv["url"] + "post",
             { :post_time => post_time },
             "rack.session" => { :user => user }
      end

      subject { last_response.status }
      it { should == 403 }
    end

    context "not give post time" do
      before do
        post TimeCapsuleEnv["url"] + "post",
             { :post => post_text },
             "rack.session" => { :user => user }
      end

      subject { last_response.status }
      it { should == 403 }
    end

    context "invalid post time given" do
      before do
        post TimeCapsuleEnv["url"] + "post",
             { :post => post_text,
               :post_time => post_time },
             "rack.session" => { :user => user }
      end

      subject { last_response.status }
      it { should == 200 }
    end
  end
end
