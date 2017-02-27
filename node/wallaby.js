require('fluentnode')

module.exports = function (wallaby) {
    return {
        files: [
            'src/**/*.coffee',
        ],

        tests: [
            'test/**/*.coffee',
        ],

        env: {
            type: 'node'
        }
    };
};