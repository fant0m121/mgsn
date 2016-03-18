// generated on 2016-03-18 using generator-webapp 2.0.0
import gulp from 'gulp';
import gulpLoadPlugins from 'gulp-load-plugins';
import browserSync from 'browser-sync';
import del from 'del';
import pug from 'gulp-pug';
import nib from 'nib';
import useref from 'gulp-useref';
import {stream as wiredep} from 'wiredep';

const $ = gulpLoadPlugins();
const reload = browserSync.reload;

gulp.task('styles', () => {
  return gulp.src('app/**/*.styl')
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.stylus({
      paths: ['app/assets/styles/helpers'],
      import: [
        '_variables.styl',
        '_mixins.styl'
      ],
      use: nib(),
      compress: true
    }))
    .pipe($.autoprefixer({browsers: ['> 1%', 'last 2 versions', 'Firefox ESR']}))
    .pipe($.concat('main.css'))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('.tmp/assets/styles'))
    .pipe(reload({stream: true}));
});

gulp.task('scripts', () => {
  return gulp.src('app/assets/scripts/**/*.js')
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.babel())
    .pipe($.sourcemaps.write('.'))
    .pipe(gulp.dest('.tmp/assets/scripts'))
    .pipe(reload({stream: true}));
});

function lint(files, options) {
  return () => {
    return gulp.src(files)
      .pipe(reload({stream: true, once: true}))
      .pipe($.eslint(options))
      .pipe($.eslint.format())
      .pipe($.if(!browserSync.active, $.eslint.failAfterError()));
  };
}
const testLintOptions = {
  env: {
    mocha: true
  }
};
gulp.task('views', () => {
  return gulp.src(['app/**/*.pug', '!app/assets/**/*'])
    .pipe($.plumber())
    .pipe(pug({
      pretty: true,
      basedir: './app'
    }))
    .pipe(gulp.dest('.tmp'));
});

gulp.task('lint', lint('app/assets/scripts/**/*.js'));
gulp.task('lint:test', lint('test/spec/**/*.js', testLintOptions));

gulp.task('html', ['styles', 'scripts', 'views'], () => {
  var assets = $.useref({searchPath:['.tmp', 'app', 'bower_components']});
  //var assets = $.useref.assets({
  //  searchPath:['.tmp', 'app', 'bower_components']
  //});

  return gulp.src(['app/*.html', '.tmp/**/*.html'])
    .pipe($.plumber())
    .pipe(assets)
    .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.cssnano()))
    .pipe($.if('*.css', $.autoprefixer({
      browsers: ['last 2 version', '> 1%', 'ie >= 9']
    })))
    .pipe($.useref())
    .pipe($.if('*.html', $.htmlmin({collapseWhitespace: true})))
    .pipe(gulp.dest('dist'));
});

gulp.task('images', () => {
  return gulp.src('app/assets/images/**/*')
    .pipe($.cache($.imagemin({
      progressive: true,
      interlaced: true,
      // don't remove IDs from SVGs, they are often used
      // as hooks for embedding and styling
      svgoPlugins: [{cleanupIDs: false}]
    })))
    .pipe(gulp.dest('dist/assets/images'));
});

gulp.task('fonts', () => {
  return gulp.src('app/assets/fonts/**/*')
    .pipe(gulp.dest('dist/assets/fonts'));
});

gulp.task('extras', () => {

  gulp.src('app/assets/files/**/*')
    .pipe(gulp.dest('dist/assets/files'));

  gulp.src('app/assets/scripts/libs/**/*')
    .pipe(gulp.dest('dist/assets/scripts/libs'));

  gulp.src('app/assets/videos/**/*')
    .pipe(gulp.dest('dist/assets/videos'));

  return gulp.src([
    'app/*.*',
    '!app/*.html',
    '!app/*.pug',
  ], {
    dot: true
  }).pipe(gulp.dest('dist'));
});

gulp.task('clean', del.bind(null, ['.tmp', 'dist']));

gulp.task('serve', ['views', 'styles', 'scripts', 'fonts'], () => {
  browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['.tmp', 'app'],
      routes: {
        '/bower_components': 'bower_components'
      }
    }
  });

  gulp.watch([
    'app/*.html',
    'app/images/**/*',
    '.tmp/fonts/**/*'
  ]).on('change', reload);

  gulp.watch('app/scripts/**/*.js', ['scripts']);
  gulp.watch('app/**/*.styl', ['styles']);
  gulp.watch('app/fonts/**/*', ['fonts']);
  gulp.watch('bower.json', ['wiredep', 'fonts']);
});

gulp.task('serve:dist', () => {
  browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['dist']
    }
  });
});

gulp.task('serve:test', ['scripts'], () => {
  browserSync({
    notify: false,
    port: 9000,
    ui: false,
    server: {
      baseDir: 'test',
      routes: {
        '/scripts': '.tmp/scripts',
        '/bower_components': 'bower_components'
      }
    }
  });

  gulp.watch('app/scripts/**/*.js', ['scripts']);
  gulp.watch('test/spec/**/*.js').on('change', reload);
  gulp.watch('test/spec/**/*.js', ['lint:test']);
});

// inject bower components
gulp.task('wiredep', () => {
  gulp.src('app/assets/styles/*.styl')
    .pipe(wiredep({
      directory: 'bower_components'
    }))
    .pipe(gulp.dest('app/assets/styles'));

  gulp.src('app/**/*.jade')
    .pipe(wiredep({
      directory: 'bower_components'
    }))
    .pipe(gulp.dest('app'));
});

gulp.task('build', ['lint', 'html', 'images', 'fonts', 'extras'], () => {
  return gulp.src('dist/**/*').pipe($.size({title: 'build', gzip: true}));
});

gulp.task('default', ['clean'], () => {
  gulp.start('build');
});
