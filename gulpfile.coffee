_ = (require './package.json').gulpfile

$ =
  gulp       :require 'gulp'
  test       :require 'gulp-mocha'
  coffee     :require 'gulp-coffee'
  lint       :require 'gulp-coffeelint'
  del        :require 'del'
  replace    :require 'gulp-replace'
  run        :require 'run-sequence'
  uglify     :require 'gulp-uglify'
  rename     :require 'gulp-rename'
  browserify :require 'gulp-browserify'

$.gulp.task 'default', (cb) -> $.run [ 'dist', 'dist-browser' ], cb

$.gulp.task 'clean', (cb) -> $.del [ _.build, _.dist ], cb

$.gulp.task 'clean-browser', (cb) ->
  $.del [ 'abstract-set.js', 'abstract-set.min.js'], cb

$.gulp.task 'lint', ->
  $.gulp
    .src [ "#{_.source}/**/*.coffee" ]
    .pipe $.lint './coffeelint.json'
    .pipe $.lint.reporter()

$.gulp.task 'build', [ 'clean', 'lint'], ->
  re = /((__)?extends?)\s*=\s*function\(child,\s*parent\)\s*\{.+?return\s*child;\s*\}/
  $.gulp
    .src [ "#{_.source}/**/*.+(coffee|litcoffee)" ]
    .pipe $.coffee bare:true
    .pipe $.replace re, '$1 = require("extends__")'
    .pipe $.gulp.dest _.build

$.gulp.task 'browserify', [ 'clean-browser', 'lint', 'build', 'test'], ->
  $.gulp
    .src [ "#{_.build}/abstract-set.js" ]
    .pipe $.browserify insertGlobals:false
    .pipe $.gulp.dest './'

$.gulp.task 'test', [ 'build' ], ->
  $.gulp
    .src [ "#{_.test}/**/*.js" ], read: false
    .pipe $.test reporter: 'tap'

$.gulp.task 'dist', [ 'build', 'test' ], ->
  $.gulp
    .src [ "#{_.build}/**", "!#{_.build}/test{,/**}" ]
    .pipe $.gulp.dest _.dist

$.gulp.task 'dist-browser', [ 'browserify' ], ->
  $.gulp
    .src [ './abstract-set.js' ]
    .pipe $.uglify()
    .pipe $.rename suffix: '.min'
    .pipe $.gulp.dest './'
