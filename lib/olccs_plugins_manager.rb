class OlccsPluginsManager
  include Singleton

  attr_accessor :filters, :input

  def initialize

    @filters = Hash.new
    @input = Hash.new

    dir = File.join(Rails.root + 'lib' + 'olccs_plugins_filters')
    $LOAD_PATH.unshift(dir)
    Dir[File.join(dir, '*.rb')].each { |file|
      f = File.basename(file, '.rb')
      require f

      @filters[f.to_sym] = OlccsPlugins.const_get(f.classify)

    }

    dir = File.join(Rails.root + 'lib' + 'olccs_plugins_input')
    $LOAD_PATH.unshift(dir)
    Dir[File.join(dir, '*.rb')].each { |file|
      f = File.basename(file, '.rb')
      require f

      @input[f.to_sym] = OlccsPlugins.const_get(f.classify)

    }

    puts "repo: #{@input.to_s}"

  end
end
