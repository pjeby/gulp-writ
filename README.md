# Literate Programming with `gulp` and `writ`

This gulp plugin lets you use [writ](https://www.npmjs.com/package/writ) in your build process, to extract code blocks (of any language) from Markdown, and optionally rearrange them in true literate programming style.  (That is, you can define chunks of code in the order it most makes sense to *explain* them, and then automatically assemble them in the order that makes sense to *run* them.)

Just name your source files `.js.md`, `.coffee.md`, or whatever other extension is suitable for your code.  Writ will look for the right kind of comment characters for that language, and `gulp-writ` will remove the `.md` part, leaving only your code.

## Usage

```javascript
var writ = require('gulp-writ');

gulp.task('build', function() {
  gulp.src('./src/*.js.md')
    .pipe(writ().on('error', gutil.log))
    //
    // any other build steps here...
    //
    .pipe(gulp.dest('./lib'))
});
```

gulp-writ has no options.  It simply runs provided files through `writ`, configured for the language designated by each file's second-level extension, and it strips the primary (`.md`, `.markdown`, etc.) extension from the output file name.

Errors will be omitted if you pass in an invalid filename or something that `writ` can't handle (like infinitely-recursive block definitions).  These errors will crash gulp, so you'll probably want to trap and log the errors (as shown in the example above), or do something more useful/interesting.

(In practice, you're much more likely to see errors from whatever you're passing writ's *output* to, than from writ itself.)

Unfortunately, writ doesn't support sourcemaps, so any sourcemap generation downstream of writ in your build process will refer to lines in writ's output, not to the original markdown input. So you may want to have your build process save that file somewhere, in case you need it to work out where an error is coming from.

Luckily, `gulp.dest()` actually outputs the files it writes, so you can do something like this:

```javascript
gulp.task('build', function() {
  gulp.src('./src/*.js.md')
    .pipe(writ().on('error', gutil.log))
    .pipe(gulp.dest('./lib'))  // save the un-minified .js
    //
    // minification, etc. goes here
    //
    .pipe(gulp.dest('./lib'))  // save the .min.js and sourcemaps alongside
});
```

to save a copy of the source at that stage, and then save a minified version alongside it.
