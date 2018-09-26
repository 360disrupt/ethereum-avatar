'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var paths = gulp.paths;
var $ = require('gulp-load-plugins')();

gulp.task('specs', ['watch-test'], function () {
  return gulp.src(paths.specs + '/**/*.spec.js')
    .pipe($.jasmine({verbose: true}));
});