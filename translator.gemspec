# -*- encoding: utf-8 -*-
# stub: translator 0.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "translator"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Hubert \u{141}\u{119}picki"]
  s.date = "2016-02-12"
  s.description = "translator is engine, that you can easily integrate with your administration panel, and let your clients do the dirty work translating the site"
  s.email = ["hubert.lepicki@amberbit.com"]
  s.files = ["LICENSE", "README.rdoc", "app/assets/javascripts/jquery.autosize-min.js", "app/backends/translator/mongo_store.rb", "app/backends/translator/redis_store.rb", "app/controllers/translator/translations_controller.rb", "app/views/layouts/translator.html.erb", "app/views/translator/translations/_form.html.erb", "app/views/translator/translations/create.js.erb", "app/views/translator/translations/destroy.js.erb", "app/views/translator/translations/index.html.erb", "config/routes.rb", "lib/translator.rb", "lib/translator/engine.rb"]
  s.homepage = "http://github.com/amberbit/translator"
  s.rubygems_version = "2.4.6"
  s.summary = "Rails engine to manage translations"
end
