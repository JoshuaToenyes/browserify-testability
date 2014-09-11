module.exports = (grunt) ->

  config =
    pkg: (grunt.file.readJSON('package.json'))

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      testability: ['src/**/*.coffee', 'test/**/*.coffee']

    coffee:
      options:
        bare: true
      dist:
        expand: true,
        flatten: true,
        cwd: 'src',
        src: ['./**/*.coffee'],
        dest: 'dist',
        ext: '.js'
      test:
        expand: true,
        flatten: false,
        cwd: 'test',
        src: ['./**/*.coffee'],
        dest: 'test',
        ext: '.js'

    copy:
      dist:
        files: [{src: ['./src/prelude.js'], dest: './dist/prelude.js'}]

    browserify:
      test:
        files:
          'test/test.js': ['test/**/*.js']
        options:
          browserifyOptions:
            debug: true
            entries: ['./test/x.js']
          preBundleCB: (b) ->
            b.plugin(require('./dist/plugin'))

    watch:
      files: ['src/**/*.coffee', 'test/**/*.coffee'],
      tasks: ['test']
      configFiles:
        files: ['Gruntfile.coffee']
        options:
          reload: true

    mochaTest:
      options:
        reporter: 'spec'
      src: ['test/*.js']

    mocha_phantomjs:
      all: ['test/**/*.html']
      
    clean:
      all: ['dist', 'test/**/*.js']
  
  grunt.initConfig(config)
  
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-browserify')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-mocha-phantomjs')

  grunt.registerTask('compile', ['coffeelint', 'clean', 'coffee', 'copy']);
  grunt.registerTask('test', ['compile', 'browserify', 'mocha_phantomjs']);
