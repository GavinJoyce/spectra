module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    uglify:
      prod:
        options:
          mangle:
            except: ['Spectra']
          report: 'gzip'
          compress:
            conditionals: true
            if_return: true
            booleans: true
            evaluate: true
            sequences: true
            properties: true
            join_vars: true
        files:
          'spectra.min.js': ['spectra.js']

    jasmine:
      dev:
        src: 'spectra.js'
        options:
          specs: 'test/**/*.js'
      prod:
        src: 'spectra.min.js'
        options:
          specs: 'test/**/*.js'

    karma:
      options:
        configFile: 'karma.conf.js'
        reporters: ['progress', 'coverage']
      ci:
        singleRun: true
        coverageReporter:
          type: 'lcov'
          dir: 'test/coverage/'

    coveralls:
      options:
        coverage_dir: 'test/coverage/'

    jshint:
      all:
        options:
          curly: true
          eqeqeq: true
          es3: true
          immed: true
          indent: 2
          latedef: true
          noarg: true
          node: true
          noempty: true
          nonew: true
          strict: true
          trailing: true
          undef: true
          unused: true
        files:
          src: 'spectra.js'

    watch:
      jshint:
        files: ['spectra.js']
        tasks: ['jshint']
      jasmine:
        files: ['*.js', 'test/**/*.js']
        tasks: ['jasmine:dev']

  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-karma-coveralls'

  grunt.registerTask 'test', ['jshint', 'jasmine:dev', 'uglify', 'jasmine:prod']
  grunt.registerTask 'build', ['uglify', 'jasmine:prod']
  grunt.registerTask 'default', ['jasmine:dev', 'watch']
  grunt.registerTask 'travis', ['test', 'karma', 'coveralls']
