require 'nil/file'
require 'nil/serialise'

require_relative 'PlayerResult'

def parseContents(contents)
  pattern = /<tr class=".+?">.+?<td class=".+?" >.+?([0-9,]+).+?<\/td>.+?<td class=".+?" >(.+?)<\/td>.+?<td class=".+?" >.+?(\d+).+?<\/td>.+?<td class=".+?" >.+?(\d+).+?<\/td>.+?<td class=".+?" >.+?(\d+).+?<\/td>.+?<\/tr>/m
  output = []
  contents.scan(pattern) do |match|
    rank = match[0].gsub(',', '').to_i
    name = match[1].strip
    wins = match[2].to_i
    losses = match[3].to_i
    rating = match[4].to_i
    result = PlayerResult.new(rank, name, wins, losses, rating)
    output << result
  end
  return output
end

def serialise
  files = Nil.readDirectory('output')
  if files == nil
    raise "Unable to read output directory"
  end
  players = []
  files.each do |file|

    contents = Nil.readFile(file.path)
    if contents == nil
      raise "Unable to read file #{file.path}"
    end
    players += parseContents(contents)
  end
  Nil.serialise(players, 'results.data')
end

serialise
