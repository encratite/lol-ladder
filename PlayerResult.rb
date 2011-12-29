class PlayerResult
  attr_reader :rank, :name, :wins, :losses, :rating

  def initialize(rank, name, wins, losses, rating)
    @rank = rank
    @name = name
    @wins = wins
    @losses = losses
    @rating = rating
  end
end
