require 'sequel'

require 'nil/serialise'

require_relative 'Configuration'
require_relative 'PlayerResult'

connectData = {
  adapter: Configuration::Adapter,
  host: Configuration::Host,
  user: Configuration::User,
  #password: Configuration::Password,
  database: Configuration::Database
}

database = Sequel.connect(connectData)

table = database[:lookup_job]
players = Nil.deserialise('data/results')
players.each do |player|
  values = {
    region: 'europe_west',
    summoner_name: player.name,
    priority: 0,
    time_added: Time.now.utc,
  }
  table.insert(values)
end
