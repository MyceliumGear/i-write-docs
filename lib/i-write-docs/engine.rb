module IWriteDocs
  class Engine < ::Rails::Engine
    isolate_namespace IWriteDocs

    config.generators do |g|
      g.template_engine :haml
    end
  end
end
