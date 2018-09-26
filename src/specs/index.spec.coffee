applicationDir = process.cwd() + '/dist'

generator = require(applicationDir + "/generator.js")

describe '>>>>>>>>>>>>>>>>>>>>>>>>>  GENERATOR  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<', () ->
  it 'generator should create avatar from valid hex address', (done) ->
    token = "0123456789a1234456789c123456789d1234456789"
    generator.generateAvatar token, (err, token, b64Image)->
      expect(err).toBeNull()
      expect(token).toMatch(token)
      expect(b64Image.indexOf("data:image/png;base64")).not.toBe(-1)
      done()

  it 'generator should create hex address', (done) ->
    generator.generateCrypto (err, token)->
      expect(err).toBeNull()
      expect(token.length).toBe(40)
      done()

  it 'generator should create color variations', (done) ->
    generator.createColors 'body-0', (err)->
      expect(err).toBeNull()
      done()

#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
return