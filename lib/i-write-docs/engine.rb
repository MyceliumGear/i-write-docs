module IWriteDocs
  class Engine < ::Rails::Engine
    # isolate_namespace IWriteDocs
    engine_name "iwd"

    paths["app/views"] << "app/views/i_write_docs"
    
    config.generators do |g|
      g.template_engine :haml
    end

  end
end
