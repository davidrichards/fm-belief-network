require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "fm-belief-network" do
  
  it "should have a NotImplemented error" do
    defined?(NotImplemented).should be_true
  end
  
  context "when extending the Fathom::Config" do
    
    after do
      Fathom.reset_config!
    end
    
    it "should be configured automatically to use :memory: for set_storage" do
      Fathom.config.set_storage.should eql(':memory:')
    end
    
    it "should be able to set the set_storage" do
      Fathom.config.set_storage = :a_different_set_storage_location
      Fathom.config.set_storage.should eql(:a_different_set_storage_location)
    end
    
    it "should have db as part of the config" do
      Fathom.config.db.should be_a(SQLite3::Database)
    end
    
    it "should be configured automatically to uses_sqlite_optimizer" do
      Fathom.config.uses_sqlite_optimizer.should be_true
    end
    
    it "should be able to set uses_sqlite_optimizer config" do
      Fathom.config.uses_sqlite_optimizer = false
      Fathom.config.uses_sqlite_optimizer.should be_false
    end
    
    it "should set db to false if not uses_sqlite_optimizer" do
      Fathom.config.uses_sqlite_optimizer = false
      Fathom.config.db.should eql(:not_implemented)
    end
    
  end
end
