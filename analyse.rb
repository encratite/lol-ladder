require 'nil/serialise'

require_relative 'PlayerResult'

class RatingStatistics
  attr_reader :range, :wins, :losses, :count

  def initialize(range)
    @range = range
    @wins = 0
    @losses = 0
    @count = 0
  end

  def process(player)
    @wins += player.wins
    @losses += player.losses
    @count += 1
  end

  def <=>(other)
    return @range <=> other.range
  end
end

def analyse
  players = Nil.deserialise('data/results')
  granularity = 50
  ratingStatistics = {}
  players.each do |player|
    range = player.rating - (player.rating % granularity)
    if ratingStatistics[range] == nil
      ratingStatistics[range] = RatingStatistics.new(range)
    end
    ratingStatistics[range].process(player)
  end
  ratingStatistics = ratingStatistics.values.sort
  offset = 0
  ratingStatistics.each do |statistics|
    games = (statistics.wins + statistics.losses).to_f / statistics.count
    winRatio = statistics.wins.to_f / (statistics.wins + statistics.losses) * 100.0
    moreWinsThanLosses = (statistics.wins - statistics.losses).to_f / statistics.count
    percentile = offset.to_f / players.size * 100.0
    printf("**#{statistics.range} Elo**: %.1f games played on average with a win ratio of %.1f%% and %.1f more wins than losses, percentile within listed population: %.1f%%\n\n", games, winRatio, moreWinsThanLosses, percentile)
    offset += statistics.count
  end
end

analyse
