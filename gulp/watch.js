'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var paths = gulp.paths;
var $ = require('gulp-load-plugins')();


gulp.task('watch-test', ['images', 'scripts-backend', 'scripts-specs'], function () {
  gulp.watch(paths.src + '/backend/**/*.py', ['images']);
  gulp.watch([paths.src + '/backend/**/*.coffee', '!' + paths.src + '/backend/**/*.spec.coffee'], ['scripts-backend']);
  gulp.watch([paths.src + '/backend/**/*.spec.coffee', '!' + paths.src + '/backend/**/*.coffee'], ['scripts-specs']);
});