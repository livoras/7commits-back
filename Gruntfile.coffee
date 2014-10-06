module.exports = (grunt)->

    grunt.initConfig
        concurrent: 
            dev: 
                tasks: ["nodemon", "watch"]
                options: 
                    logConcurrentOutput: true

        simplemocha: 
            options: 
                compilers: "coffee:coffee-script"
            all: {src: ["test/**/*.coffee"]}

        watch: 
            dev:
                files: ["**/*.coffee", "**/*.jade"]
                tasks: ["simplemocha"]

        nodemon:
            dev: 
                script: "debug.coffee"
                options:
                    ext: "js,coffee,jade"
                    debug: true
                    env:
                        DEBUG: "7commits"
                        NODE_ENV: "7commits"


    grunt.loadNpmTasks 'grunt-simple-mocha'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-nodemon'
    grunt.loadNpmTasks 'grunt-concurrent'

    grunt.registerTask('default', ['simplemocha', 'concurrent:dev']);
    grunt.registerTask('test', 'simplemocha');
    grunt.registerTask('dev', ['simplemocha', 'watch']);
