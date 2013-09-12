require 'json'

class GameRecorder

  def self.write_move(id, move, token,
                      file=File.open("game_history.json","w+"))

    file_contents = JSON.load(file.read)
    to_add = {
      "token" => token,
      "position" => move
    }
    contents = file_contents || Hash.new
    all_games = contents["games"] || Hash.new
    

    if all_games[id.to_s]
      the_game = all_games[id.to_s]
    else
      the_game = Hash.new
      all_games[id.to_s] = the_game
    end

     if the_game["moves"]
       move_list = the_game["moves"]
     else
       move_list = []
       the_game["moves"] = move_list
     end

    new_move_list = move_list.concat([to_add])

    new_contents = {"games" => all_games}
    file.write(JSON.dump(new_contents))
    file.close
  end

  def self.write_winner(id,winner,file)
    file_contents = JSON.load(file.read)
    contents = file_contents || Hash.new
    all_games = contents["games"] || Hash.new

    if all_games[id.to_s]
      the_game = all_games[id.to_s]
      the_game["winner"] = winner
    else
      the_game = Hash.new
      all_games[id.to_s] = the_game
      the_game["winner"] = winner
    end

    new_contents = {"games" => all_games}
    file.write(JSON.dump(new_contents))
    file.close
  end
  
end
