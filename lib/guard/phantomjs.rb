require 'guard'
require 'guard/guard'

module Guard
  class PhantomJS < Guard

    def initialize(watchers = [], options = {})
      super

      # @options[:runner] ||= 'run-jasmine.js'
      @options[:server] ||= 'http://127.0.0.1:8888/'
      @options = options
    end

    def start
      UI.info 'Guard::PhantomJS is running!'
    end

    def run_on_changes(paths)
      return if paths.empty?

      test = @options.has_key?(:file) ? @options[:file] : @options[:server]
      cmd = "phantomjs #{@options[:runner]} #{test}"

      result = %x[#{cmd}]

      success_pattern = @options[:qunit] ? /Failed: 0/ : /0 failures/
      notify(result, result =~ success_pattern ? :success : :failed)
      puts result unless result =~ success_pattern
    end


    private

    def notify(message, image)
      framework = @options[:qunit] ? "QUnit" : "Jasmine"
      Notifier.notify(message, :title => "#{framework} results",
        :image => image)
    end

  end
end
