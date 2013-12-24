lapis = require "lapis"

import Model from require "lapis.db.model"
class Games extends Model

lapis.serve class extends lapis.Application
  "/": =>
    "Welcome to Lapis #{require "lapis.version"}!"

  [games: "/games/:id"]: =>
    id = @params.id
    game = Games\find id
    if game then
      game.json
    else
      ""
