config = exports

if not process.env.NODE_ENV
    process.env.DEBUG = "7commits"
    process.env.NODE_ENV = "DEV"

config.host = "http://localhost:3000"
config.UPLOAD_IMG_DIR = "#{__dirname}/public/uploads/images"
config.IMG_ROOT = "/uploads/images"

config.TEST_DB_URI = "mongodb://localhost/mocha-test"
config.PRODUCTION_DB_URI = "mongodb://localhost/7commits"
