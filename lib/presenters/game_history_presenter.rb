require_relative '../history'

class GameHistoryPresenter

  def self.show_games(path)
    games = History.compute_file_contents(path)["games"]
    games_presentation = ""
    game_ids = games.keys
    game_ids.each do |id|
      games_presentation += self.game_header(id)
      games_presentation += self.game_body(games[id]) 
      games_presentation += self.game_footer
    end
    games_presentation
  end

  private

  def self.game_header(id)
    "<div class='game' id='#{id}'>Game #{id}"
  end

  def self.game_footer
    dashes = "-" * 20
    dashes + "</div>"
  end

  def self.game_body(game)
    body = ""
    if game["moves"]
      body += self.move_list(game["moves"])
    end
    body += self.winner(game["winner"]) 
  end

  def self.winner(winner)
    winner_string = ""
    if winner
      winner_string += "#{winner.capitalize} won"
      winner_string += "<br /><br />"
    end
    winner_string
  end

  def self.move_list(move_list)
    move_list_string = "<ol>"
    move_list.each do |move|
      move_list_string += "<li>#{move["token"]} moved to #{move["position"]}</li>"   
      end
    move_list_string += "</ol>"
  end
end



