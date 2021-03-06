class GameTransformer

  def self.add_move(games, token, move, id)
    to_add = {
      "token" => token,
      "position" => move
    }

     self.add_to_game(games, id) do |game|
       if game["moves"]
         move_list = game["moves"]
       else
         move_list = []
         game["moves"] = move_list
       end
       move_list << to_add if to_add["position"] != 0
     end

  end

  def self.add_winner(games, winner, id)

     self.add_to_game(games, id) do |game|
       game["winner"] = winner
     end

  end

  def self.game_by_id(games, id)
    default_structure = {"moves" => [], "winner" => nil}
    games["games"][id] || default_structure 
  end
  
  private

  def self.add_to_game(games, id)
    all_games = games["games"]
    the_game = self.find_or_add_game(all_games, id)
    yield the_game
    return {"games" => all_games}
  end

  def self.find_or_add_game(games, id)
    if games[id.to_s]
      the_game = games[id.to_s]
    else
      the_game = Hash.new
      games[id.to_s] = the_game
    end
  end

end
