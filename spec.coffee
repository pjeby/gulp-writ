should = require('chai').should()
gulpwrit = require './'
writ = require 'writ'
fs = require 'fs'
describe "gulp-writ", ->
    it "should emit errors for streaming files", (done)->
        gulpwrit()
        .on 'error', (e) ->
            e.message.should.equal("Can't stream files")
            done()
        .on 'data', -> throw new Error("Shouldn't have emitted")
        .write {isNull: (-> no), isStream: (-> yes)}

    it "should emit writ's own errors", (done) ->
        gulpwrit()
        .on 'error', (e) ->
            e.message.should.equal('Recursion limit exceeded')
            done()
        .on 'data', -> throw new Error("Shouldn't have emitted")
        .write {
          isNull: (-> no), isStream: (-> no),
          path: fpath = 'fixtures/recursion.coffee.md',
          contents: new Buffer(fs.readFileSync(fpath))
        }

    checkContents = (compiled, outPath, done) -> (f) ->
        should.exist(f)
        should.exist(f.contents)
        should.exist(f.path)
        f.path.should.equal(outPath)
        String(f.contents).should.equal(compiled)
        done.call(this)

    it "should compile the input and rename the file", (done) ->
        inPath = 'fixtures/demo.js.md'
        outPath = 'fixtures/demo.js'
        contents = fs.readFileSync(inPath)
        compiled = writ.compile(String(contents), 'js')
        gulpwrit()
        .on 'error', done
        .on 'data', checkContents(compiled, outPath, done)
        .write {isNull: (-> no), isStream: (-> no), path: inPath, contents}

    it "should change the .litcoffee extension to .coffee", (done) ->
        inPath = 'fixtures/demo.litcoffee'
        outPath = 'fixtures/demo.coffee'
        contents = '```\n"use strict"\n```'
        compiled = writ.compile(contents, 'coffee')
        gulpwrit()
        .on 'error', done
        .on 'data', checkContents(compiled, outPath, done)
        .write {isNull: (-> no), isStream: (-> no), path: inPath, contents}
