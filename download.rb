require 'nil/file'
require 'nil/http'

def processLadder
  baseURL = 'http://competitive.euw.leagueoflegends.com/ladders/euw/current/rankedsolo5x5?summoner_name=&page='
  finalString = 'No Results Were Found'
  outputDirectory = 'output'
  page = 0
  while true
    url = baseURL + page.to_s
    path = Nil.joinPaths(outputDirectory, page.to_s)
    if !File.exists?(path)
      puts "Downloading #{url}"
      contents = Nil.httpDownload(url)
      if contents == nil
        raise "Unable to download #{url}"
      end
      if contents.index(finalString) != nil && page >= 6000
        break
      end
      Nil.writeFile(path, contents)
    end
    page += 1
  end
end

processLadder
