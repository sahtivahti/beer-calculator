express = require 'express'
bodyparser = require 'body-parser'
Brauhaus = require 'brauhaus'

app = express()
app.use bodyparser.json()

app.get '/health', (req, res) -> res.json {}

app.post '/analyze', (req, res) ->
  body = req.body

  recipe = new Brauhaus.Recipe
    batchSize: +body.batchSize
    boilSize: +body.boilSize

  for _, f of body.fermentables
    recipe.add 'fermentable',
      yield: 70
      color: Brauhaus.ebcToSrm(+f.color)
      weight: +f.weight

  for _, hop of body.hops
    recipe.add 'hop',
      weight: +hop.weight
      aa: +hop.aa
      time: +hop.time
      use: 'boil'
      form: 'pellet'

  recipe.calculate()

  res.json
    og: +recipe.og.toFixed(2)
    fg: +recipe.fg.toFixed(2)
    abv: +recipe.abv.toFixed(2)
    colorSrm: +recipe.color.toFixed(2)
    colorEbc: +Brauhaus.srmToEbc(recipe.color).toFixed(2)
    colorName: recipe.colorName()
    ibu: +recipe.ibu.toFixed(2)

app.listen 3000, console.log "App started at http://localhost:3000"
