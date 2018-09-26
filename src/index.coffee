inspect = require('util').inspect
chalk = require('chalk')
debugGenerator = require('debug')('generator')

crypto = require('crypto')
async = require('async')
fs = require('fs')
mergeImages = require('merge-images')
Canvas = require('canvas')
imageSize = require('image-size')
jimp = require('jimp')


#---------------------------------------- Current Settings ---------------------------------------------
images = {
  background: 8
  body: 3
  gadget: 2
  bowTie: 5
  face: 2
  hat: 2
  eyes: 4
  mouth: 6
  moustache: 2
  glasses: 2
}

removeTreshold = {
  bowTie: 8
  moustache: 5
  glasses: 5
}

config = {
  face: [null, {y:80}]
  hat: [null, {x:20, y:50}]
  gadget: [null, {x:-12, y:236}]
}

partsBase = {
  background: { src: 'background-', x: 12, y: 70 },
  body: { src: 'body-', x: 0, y: 0 },
  bowTie: { src: 'bow-tie-', x: 53, y: 160 },
  face: { src: 'face-', x: 37, y: 110 },
  hat: { src: 'hat-', x: 40, y: 45 },
  eyes: { src: 'eyes-', x: 75, y: 130 },
  mouth: { src: 'mouth-', x: 100, y: 165 },
  moustache: { src: 'moustache-', x: 65, y: 145 },
  glasses: { src: 'glasses-', x: 42, y: 120 },
  gadget: { src: 'gadget-', x: 2, y: 250 },
}

vanity = {
  '926b913842f52fb4ca42533f6fbdf6e2a702e95f': {src: __dirname + '/images/grumpy.png',  x: 6, y: 45}
}

# ----------------------------------------- Helpers  -----------------------------
modulo = (hexString, max)->
  max = max || 1
  m = (parseInt(hexString, 16) % max).toString(16)
  debugGenerator "#{hexString}", inspect m
  return m

remove = (key, hexString)->
  return false if !removeTreshold[key]?
  return parseInt(hexString, 16) > removeTreshold[key]


exports.generateCrypto = (callback)->
  crypto.randomBytes 20, (err, buffer) ->
    return callback err if err?
    token = buffer.toString('hex')
    return callback null, token

# ----------------------------------------- Build the avatar -----------------------------
defineAvatarParts = (token, callback) ->
  parts = JSON.parse JSON.stringify partsBase

  full = [{src: __dirname + '/images/' + 'canvas.png'}]
  index = 0
  for key of parts
    index++
    if !remove(key, token[index])
      parts[key].src = __dirname + '/images/' + parts[key].src
      nr = modulo token[index], images[key]
      parts[key].src += nr
      parts[key].src += '.png'

      if config[key]?[nr]?
        parts[key].y = config[key][nr].y if config[key][nr].y?
        parts[key].x = config[key][nr].x if config[key][nr].x?

      full.push parts[key]

  full = [{src: __dirname + '/images/' + 'canvas.png'}, vanity[token]] if vanity[token]?

  debugGenerator full
  return callback null, full

exports.generateAvatar = (token, callback) ->
  debugGenerator "token: ", token
  defineAvatarParts token, (err, full)->
    mergeImages(full, {
      Canvas: Canvas
    }).then (b64Image)->
      return callback null, token, b64Image
    , (errMerge)->
      async.each full, (element, next)->
        fs.stat element.src, (err, stats)->
          if err?
            debugGenerator "err", err
            return next err
          next()
      , (err)->
        return callback err

# ----------------------------------------- Helper to generate color variations (remove in production) -----------------------------
exports.createColors = (name, callback)->
  jimp.read __dirname + "/images/#{name}.png", (err, image)->
    return callback err if err?
    async.times 16, (index, next)->
      debugGenerator index, "hue rot:", index*360/16
      image.color([{ apply: 'hue', params: [index*360/16] }])
      image.getBuffer 'image/png', (err, buffer)->
        return callback err if err?
        debugGenerator "Writing file to", __dirname + "/images/#{name}-#{index.toString(16)}.png"
        fs.writeFile __dirname + "/images/#{name}-#{index.toString(16)}.png",buffer, next
    , callback
