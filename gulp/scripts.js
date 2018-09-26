'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var paths = gulp.paths;
var $ = require('gulp-load-plugins')();


gulp.task('scripts-backend', function () {
  return gulp.src([paths.src + '/**/*.coffee', '!' + paths.src + '/**/*.spec.coffee'])
    .pipe($.coffeelint())
    .pipe($.coffeelint.reporter())
    .pipe($.coffee())
    .on('error', function handleError(err) {
      console.error(err.toString());
      this.emit('end');
    })
    .pipe(gulp.dest(paths.dist + '/'))
});

gulp.task('scripts-specs', function () {
  return gulp.src([paths.src + '/**/specs/*.spec.coffee'])
    .pipe($.coffeelint())
    .pipe($.coffeelint.reporter())
    .pipe($.coffee())
    .on('error', function handleError(err) {
      console.error(err.toString());
      this.emit('end');
    })
    .pipe(gulp.dest(paths.specs + '/'))
});