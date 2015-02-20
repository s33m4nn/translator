# encoding: UTF-8
require 'spec_helper'

RSpec.describe Translator::TranslationsController do

  before :all do
    conn = Mongo::Connection.new.db("translator_test").collection("translations")
    Translator.current_store = Translator::MongoStore.new(conn)
    I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
  end

  after :all do
    Translator.auth_handler = nil
  end

  describe "GET index" do
    context "auth_handler" do
      it "responds OK with no auth proc" do
        get :index, use_route: '/'
        expect(response.status).to eq(200)
      end

      it "responds 401 with auth proc defined" do
        Translator.auth_handler = proc {
          head 401
        }
        get :index, use_route: '/'
        expect(response.status).to eq(401)
      end
    end
  end
end
