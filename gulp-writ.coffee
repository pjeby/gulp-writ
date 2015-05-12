{PluginError} = require 'gulp-util'
writ = require 'writ'

module.exports = -> require('through2').obj (file, enc, done) ->

    if file.isNull()
        return done(null, file)

    else if file.isStream()
        return done(new PluginError('gulp-writ', "Can't stream files"))

    try
        # Remove the .md from the filename
        parts = file.path.split('.')
        parts.pop()
        file.path = parts.join('.')

        # Get the language from the remaining extension
        lang = parts[parts.length-1]

        result = writ.compile(file.contents.toString('utf8'), lang)
        file.contents = new Buffer(result)

    catch e
        return done(new PluginError('gulp-writ', e))

    return done(null, file)
