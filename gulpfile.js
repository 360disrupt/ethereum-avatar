'use strict';

var gulp = require('gulp');

gulp.paths = {
  src: 'src',
  dist: 'dist',
  specs: 'specs'
};

require('require-dir')('./gulp');

gulp.task('default', ['images', 'scripts-backend'])
