class OlccsPluginsManager
  include Singleton

  attr_accessor :repository

  def initialize

    @repository = Hash.new

    dir = File.join(Rails.root + 'lib' + 'olccs_plugins')
    $LOAD_PATH.unshift(dir)
    Dir[File.join(dir, '*.rb')].each { |file|
      f = File.basename(file, '.rb')
      require f

      @repository[f.to_sym] = OlccsPlugins.const_get(f.classify)

    }

    puts "repo: #{@repository.to_s}"

  end
end
