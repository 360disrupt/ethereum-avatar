'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var paths = gulp.paths;
var $ = require('gulp-load-plugins')();

gulp.task('images', function () {
  return gulp.src(paths.src + '/**/*.{jpg,jpeg,png,svg,gif}')
    .pipe(gulp.dest(paths.dist + '/'))
});