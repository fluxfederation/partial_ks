module PartialKs
  class Sync
    attr_reader :models_list
    delegate :issues, to: :models_list

    def initialize(manual_configuration)
      @models_list = ModelsList.new(manual_configuration)
    end

    def run!(&block)
      Runner.new(models_list.all).run!(&block)
    end
  end
end
