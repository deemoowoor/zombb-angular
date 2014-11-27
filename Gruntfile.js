'use strict';

module.exports = function(grunt) {

    // load all grunt tasks automatically
    require('load-grunt-tasks')(grunt);

    var mountFolder = function(connect, dir) {
        return connect.static(require('path').resolve(dir));
    };

    var cfg = {
        srcDir: 'app',
        buildDir: 'dist',
        demoDir: 'demo',
        testDir: 'test',
        zombbDir: '../zombb/public'
    };

    grunt.initConfig({
        cfg: cfg,
        pkg: grunt.file.readJSON('package.json'),

        watch: {
            livereload: {
                files: [
                    '<%= cfg.demoDir %>/**/*.js',
                    '<%= cfg.demoDir %>/**/*.css',
                    '<%= cfg.demoDir %>/**/*.html',
                    '!<%= cfg.buildDir %>/*.js',
                    '!<%= cfg.demoDir %>/dist/*.js',
                    '!<%= cfg.demoDir %>/bower_components/**/*'
                ],
                options: {
                    livereload: true
                }
            },
            build: {
                files: [
                    '<%= cfg.srcDir %>/**/*.js',
                    '!<%= cfg.buildDir %>/*.js'
                ],
                tasks: ['jshint:source', 'clean:build', 'coffee:build', 'uglify:build', 'sass:build', 'cssmin', 'copy:demo']
            },
            cssmin: {
                files: [
                    '<%= cfg.srcDir %>/**/*.css'
                ],
                tasks: ['sass:build', 'cssmin', 'copy']
            }
        },

        coffee: {
            build: {
                files: {
                    '<%= cfg.buildDir %>/zombb.js': ['<%= cfg.srcDir %>/zombb.coffee',
                        '<%= cfg.srcDir %>/controllers/*.coffee']
                }
            }
        },

        uglify: {
            options: {
                preserveComments: 'some',
                mangle: false,
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            build: {
                files: {
                    '<%= cfg.buildDir %>/zombb.min.js': '<%= cfg.buildDir %>/zombb.js'
                }
            }
        },

        clean: {
            build: {
                src: ['<%= cfg.buildDir %>/**']
            },
            demo: {
                src: ['<%= cfg.demoDir %>/dist/**']
            }
        },

        sass: {
            demo: {
                options: {
                    style: 'expanded'
                },
                files: {
                    '<%= cfg.buildDir %>/main.css': '<%= cfg.srcDir %>/main.scss',
                    '<%= cfg.buildDir %>/zombb.css': '<%= cfg.srcDir %>/zombb.scss'
                }
            },
            build: {
                options: {
                    style: 'expanded'
                },
                files: {
                    '<%= cfg.buildDir %>/zombb.css': ['<%= cfg.srcDir %>/zombb.scss']
                }
            }
        },

        cssmin: {
            add_banner: {
                options: {
                    banner: '/* ZomBB css file */'
                },
                files: {
                    '<%= cfg.buildDir %>/zombb.min.css': ['<%= cfg.buildDir %>/zombb.css']
                }
            }
        },

        // prepare files for demo
        copy: {
            demo: {
                files: [{
                    expand: true,
                    src: '<%= cfg.buildDir %>/*.*',
                    dest: '<%= cfg.demoDir %>/'
                },
                {
                    expand: true,
                    flatten: true,
                    src: ['<%= cfg.srcDir %>/*.html', '<%= cfg.srcDir %>/partials/*.html'],
                    dest: '<%= cfg.demoDir %>/',
                    filter: 'isFile'
                },
                {
                    expand: true,
                    flatten: true,
                    src: ['<%= cfg.srcDir %>/images/*.*'],
                    dest: '<%= cfg.demoDir %>/images/',
                    filter: 'isFile'
                },
                {
                    expand: true,
                    src: ['<%= cfg.demoDir %>/**/*'],
                    dest: '<%= cfg.zombbDir %>/'
                }]
            }
        },

        connect: {
            options: {
                port: 9000,
                livereload: 35729,
                hostname: '0.0.0.0'
            },
            demo: {
                options: {
                    middleware: function(connect) {
                        return [
                            mountFolder(connect, '')
                        ];
                    }
                }
            }
        },

        open: {
            server: {
                path: 'http://localhost:<%= connect.options.port %>/<%= cfg.demoDir %>/'
            }
        },

        jshint: {
            options: {
                'jshintrc': true,
                reporter: require('jshint-stylish')
            },
            source: {
                files: {
                    src: ['<%= cfg.srcDir %>/**/*.js']
                }
            },
            demo: {
                files: {
                    src: [
                        '<%= cfg.demoDir %>/**/*.js',
                        '!<%= cfg.demoDir %>/bower_components/**/*'
                    ]
                }
            }
        },

        jscs: {
            src: ['<%= cfg.srcDir %>/**/*.js', '<%= cfg.testDir %>/*.js']
        },

        // karma
        karma: {
            options: {
                configFile: 'karma.conf.js',
                autoWatch: true
            },

            single: {
                singleRun: true,
                browsers: ['PhantomJS']
            },

            continuous: {
                singleRun: false,
                browsers: ['PhantomJS', 'Firefox']
            }
        },
        // available tasks
        tasks_list: {
            options: {},
            project: {
                options: {
                    tasks: [{
                        name: 'build',
                        info: 'Create a build of (tested) the source files'
                    }, {
                        name: 'webserver',
                        info: 'Build the project, watch filechanges and start a webserver'
                    }, {
                        name: 'test',
                        info: 'Runt tests'
                    }, {
                        name: 'test:continuous',
                        info: 'Runt tests continuously'
                    }]
                }
            }
        },
    });

    grunt.registerTask('default', ['tasks_list:project']);
    grunt.registerTask('build', ['jscs:src', 'jshint:source', 'clean:build', 'coffee:build', 'sass:build', 'cssmin', 'uglify:build', 'copy']);
    grunt.registerTask('webserver', ['build', 'open', 'connect:demo', 'watch']);
    grunt.registerTask('test', ['jscs:src', 'jshint:source', 'karma:single']);
    grunt.registerTask('test:continuous', ['karma:continuous']);
};
