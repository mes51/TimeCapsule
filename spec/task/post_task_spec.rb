require "spec_helper.rb"

describe PostTask do
  let(:day) { 24 * 3600 }
  let(:latest_post_time) { 10 * day }
  #FIXME: change your twitter id and access key
  let(:user_id) { 444420137 }
  let(:screen_name) { "TimeMachineTest" }
  let(:access_key) { "444420137-VcxV0606pltj3PCm2Xb0nBlOgfA0wtODzkldlf6N" }
  let(:access_key_secret) { "hChTRh34NAr2JfX0V8sbpV9ojR0VJXAbMEoFrHQh9jE" }

  before do
    logger = Logger.new(STDOUT)#(File.open("logs/spec.txt", "a+"))
    logger.level = Logger::DEBUG
    stub(Twitter).update { |text, opt|
      logger.debug(text + " " + opt.to_s)
    }

    User.new({ :user_id => user_id,
               :screen_name => screen_name,
               :access_key => access_key,
               :access_key_secret => access_key_secret }).save
  end

  after do
    User.delete_all
  end

  describe "run" do
    context "none post" do
    end

    context "posted" do
      before do
        stub(Time).now { Time.new(2011, 12, 25) }
        10.times do |i|
          p = Post.new({ :user_id => user_id,
                         :post => "test " + i.to_s,
                         :post_time => Time.now + (i + 1) * day})
          p.save
        end
      end

      after do
        Post.delete_all
      end

      context "now is earlier than all post time" do
        before do
          stub(Time).now { Time.new(2010, 12, 25) }
          PostTask.run
        end

        subject { Post.where.count }
        it { should == 10 }
      end

      context "now is later than all post time" do
        before do
          stub(Time).now { Time.new(2011, 12, 26) + latest_post_time }
          PostTask.run
        end

        subject { Post.where.count }
        it { should == 0 }
      end

      context "now is later than sum post time" do
        before do
          stub(Time).now { Time.new(2011, 12, 25) + 5 * day }
          PostTask.run
        end

        subject { Post.where.count }
        it { should == 5 }
      end
    end
  end
end
