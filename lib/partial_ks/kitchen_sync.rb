module PartialKs
  class KitchenSync
    attr_reader :models_list

    def initialize(manual_configuration)
      @models_list = ModelsList.new(manual_configuration).all
    end

    def run!(&block)
      Runner.new(models_list).run!(&block)
    end
  end
end
