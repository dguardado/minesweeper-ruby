# Your tests should require this file which sets up the test harness.
require 'minitest/autorun'
require 'minitest/reporters'

reporter_options = { color: true }
reporters = [Minitest::Reporters::DefaultReporter.new(reporter_options)]
Minitest::Reporters.use! reporters
