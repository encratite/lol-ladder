require 'nil/file'
require 'nil/console'

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

def floatingPointString(input, percentage = true)
  output = sprintf('%.1f', input)
  if percentage
    output += '%'
  end
  return output
end

def analyse(players)
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
  rows = [
    [
      'Elo',
      'Games played',
      'Win ratio',
      'Win/loss difference',
      'Percentile',
    ]
  ]
  ratingStatistics.each do |statistics|
    games = (statistics.wins + statistics.losses).to_f / statistics.count
    winRatio = statistics.wins.to_f / (statistics.wins + statistics.losses) * 100.0
    moreWinsThanLosses = (statistics.wins - statistics.losses).to_f / statistics.count
    percentile = offset.to_f / players.size * 100.0
    row = [
      statistics.range.to_s,
      floatingPointString(games, false),
      floatingPointString(winRatio),
      (moreWinsThanLosses >= 0 ? '+' : '') + floatingPointString(moreWinsThanLosses, false),
      floatingPointString(percentile),
    ]
    rows << row
    offset += statistics.count
  end
  Nil.printTable(rows)
end

def loadData(path)
  lines = Nil.readLines(path)
  players = []
  pattern = /(\d+)(.+?) (?:NA|EUW|EUN) .*?(\d+).*?(\d+)W\/(\d+)L.*?(?:\d+):(?:\d+):(?:\d+):(?:\d+)/
  lines.each do |line|
    match = pattern.match(line)
    if match == nil
      next
    end
    rank = match[1].to_i
    name = match[2].strip
    rating = match[3].to_i
    wins = match[4].to_i
    losses = match[5].to_i
    player = PlayerResult.new(rank, name, wins, losses, rating)
    if rating < 400 || rating > 2700
      puts line
      puts player.inspect
      exit
    end
    players << player
  end
  return players
end

players = loadData(ARGV[0])
analyse(players)
