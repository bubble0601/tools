require_relative 'main'
Dir.glob('*/init.rb', base: __dir__).sort.each{ |f| require_relative f }
Dir.glob('*.rb', base: __dir__).sort.each{ |f| require_relative f }
