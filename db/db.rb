class DB
  class << self
    attr_accessor :ids
  end

  FILENAME = File.expand_path("ids.yml", File.dirname(__FILE__))
  self.ids = YAML.load_file(FILENAME)

  class << self
    def for_voucher
      retrieve_and_update :voucher
    end

    def for_configuration
      retrieve_and_update :configuration
    end

    def retrieve_and_update(klass)
      id = ids[klass] += 1
      File.open(FILENAME, 'w') { |f| f.write(ids.to_yaml) }
      id
    end
  end
end
