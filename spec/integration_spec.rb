ENV["RACK_ENV"] = "test"

require 'rack/test'
require_relative '../app'

describe "integration" do

  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  before(:each) do
    ClientSocket.any_instance.stub(:connect!)
    File.stub(:write)
  end

  context "with service" do

    let(:game_info) { double(:game_info) }

    before(:each) do
      History.stub(:write_move)
      History.stub(:write_winner)
      GameInformation.stub(:new).and_return(game_info)
    end

    it "hands the game state and configurations to AI" do
      rack_mock_session.cookie_jar["depth"] = 10
      rack_mock_session.cookie_jar["winner"] = nil
      rack_mock_session.cookie_jar["id"] = 75
      move = 6
      token = "x"
      id_in_response = "75\n"
      current_board_state = {move.to_s => token,
                             "depth" => "10",
                             "winner" => "",
                             "id" => id_in_response}

      NextPlayer.should_receive(:move).once.with(current_board_state)
      post '/move', {:player_move => move}
    end
  end

  context "with History" do

    let(:id) { 24 }

    before(:each) do
      rack_mock_session.cookie_jar["id"] = id
    end

    it "delegates moves to History" do
      NextPlayer.stub(:move).and_return(4)
      GameInformation.any_instance.stub(:winner_on_board)

      History.should_receive(:write_move).once.with(id,34,"x", app.settings.history_path)
      History.should_receive(:write_move).once.with(id,4,"o", app.settings.history_path)

      post '/move', {:player_move => 34}
    end

    it "delegates winners to History" do
      NextPlayer.stub(:move)
      GameInformation.any_instance.stub(:winner_on_board).and_return("x")
      History.should_receive(:write_winner).once.with(id,"x", app.settings.history_path)

      post '/move'
    end
    
  end

  context "with Random" do

    it "calls History for next i.d" do
      NextPlayer.stub(:move)
      GameInformation.any_instance.stub(:winner_on_board)
      History.should_receive(:next_id).
        and_return(50)

      post '/move'
      rack_mock_session.cookie_jar["id"].should == "50"
    end
  end

end
