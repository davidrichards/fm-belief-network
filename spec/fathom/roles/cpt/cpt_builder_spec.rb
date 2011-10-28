require File.expand_path('../../../../spec_helper', __FILE__)

include Fathom

describe CPTBuilder do
  
  before do
    @v1 = Variable.infer(:v1)
    @v2 = Variable.infer(:v2)
    @v3 = Variable.infer(:v3)
    @cpt = CPT.new(:causal_variables => [@v1, @v2], :target_variable => @v3)
    @cpt.extend CPTBuilder
  end
  
  after do
    Fathom.reset_config!
  end
  
  it "should have a create_table! method" do
    @cpt.should respond_to(:create_table!)
  end
  
  it "should have a useful table_creation_sql statement (protected method)" do
    sql = @cpt.send(:table_creation_sql).strip
    # Important: white-case sensitive.  If this breaks, play with the indent of the bottom lines.
    expected = "CREATE TABLE IF NOT EXISTS v3_via_v1_v2 (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            probability FLOAT,
            value INTEGER,
            v1 INTEGER,
            v2 INTEGER
          );"
    sql.should eql(expected)
  end
  
  it "should have a useful table_creation_sql statement for non-standard variable names" do
    @v1 = Variable.infer("Non Standard")
    @v2 = Variable.infer("Variable Names")
    @v3 = Variable.infer("Can't be BEAT")
    @cpt = CPT.new(:causal_variables => [@v1, @v2], :target_variable => @v3)
    @cpt.extend CPTBuilder
    sql = @cpt.send(:table_creation_sql).strip
    # Important: white-case sensitive.  If this breaks, play with the indent of the bottom lines.
    expected = "CREATE TABLE IF NOT EXISTS can_t_be_beat_via_non_standard_variable_names (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            probability FLOAT,
            value INTEGER,
            non_standard INTEGER,
            variable_names INTEGER
          );"
    sql.should eql(expected)
  end
  
  it "should execute the table_creation_sql" do
    Fathom.config.db.should_receive(:execute).with(@cpt.send(:table_creation_sql)).and_return(true)
    @cpt.create_table!
  end
  
  it "should have an exhaustive default_records list based on prior odds" do
    @cpt.default_records.should eql([
      {"v1"=>true, "v2"=>true, "value"=>true, "probability"=>0.5}, 
      {"v1"=>true, "v2"=>true, "value"=>false, "probability"=>0.5}, 
      {"v1"=>true, "v2"=>false, "value"=>true, "probability"=>0.5}, 
      {"v1"=>true, "v2"=>false, "value"=>false, "probability"=>0.5}, 
      {"v1"=>false, "v2"=>true, "value"=>true, "probability"=>0.5}, 
      {"v1"=>false, "v2"=>true, "value"=>false, "probability"=>0.5}, 
      {"v1"=>false, "v2"=>false, "value"=>true, "probability"=>0.5}, 
      {"v1"=>false, "v2"=>false, "value"=>false, "probability"=>0.5}
    ])
  end
  
  it "should create a reasonable insert statement, converting each data type effectively (protected method)" do
    @v1 = Variable.new(:name => :booleans, :outcomes => [true, false])
    @v2 = Variable.new(:name => :more_booleans, :outcomes => [false, true])
    @v3 = Variable.new(:name => :strings, :outcomes => ['a', 'b'])
    @v4 = Variable.new(:name => :symbols, :outcomes => [:a, :b])
    @v5 = Variable.new(:name => :integers, :outcomes => [1,2])
    @v6 = Variable.new(:name => :floats, :outcomes => [0.5, 0.75])
    @v7 = Variable.new(:name => :v6)
    @cpt = CPT.new(:causal_variables => [@v1, @v2, @v3, @v4, @v5, @v6], :target_variable => @v7)
    @cpt.extend CPTBuilder
    hash = @cpt.default_records.first
    @cpt.send(:insert_sql_for, hash).should eql("INSERT INTO v6_via_booleans_more_booleans_strings_symbols_integers_floats (booleans, more_booleans, strings, symbols, integers, floats, value, probability) VALUES ( 1, 0, 'a', 'a', 1, 0.5, 1, 0.5 )")
  end
  
  it "should be able to insert the records into the data table" do
    @cpt.create_table!
    @cpt.fill_table!
    count = Fathom.config.db.get_first_value("SELECT count(*) from #{@cpt.table_name}").should eql(8)
    
    Fathom.config.db.results_as_hash = true
    rows = Fathom.config.db.execute("SELECT * from #{@cpt.table_name}")

    # From: {"v1"=>1, "v2"=>1, "value"=>1, "probability"=>0.5},
    rows[0]['v1'].should eql(1)
    rows[0]['v2'].should eql(1)
    rows[0]['value'].should eql(1)
    rows[0]['probability'].should eql(0.5)
  end
  
  it "should update the table after fill_table!" do
    hashes = [{"v1"=>1, "v2"=>1, "value"=>1, "probability"=>0.5}]
    @cpt.create_table!
    @cpt.fill_table!(hashes)
    @cpt.table.should eql(hashes)
  end
  
  it "should prepare the attributes with the default CPT hashes automatically" do
    @cpt.table.should eql(@cpt.default_records)
  end
  
  it "should typecast the values inserted into the table" do
    hashes = [{"v1"=>true, "v2"=>true, "value"=>true, "probability"=>0.5}]
    Fathom.config.db.should_receive(:execute).with("INSERT INTO v3_via_v1_v2 (v1, v2, value, probability) VALUES ( 1, 1, 1, 0.5 )").and_return(true)
    @cpt.fill_table!(hashes)
  end
  
  it "should not attempt to create a database table if Fathom.config.uses_sqlite_optimizer is false" do
    Fathom.config.uses_sqlite_optimizer = false
    db = double("fake db")
    db.should_not_receive(:execute)
    Fathom.config.send(:instance_variable_set, :@db, db)
    @cpt.create_table!
  end
  
  it "should not attempt to write to a database table if Fathom.config.uses_sqlite_optimizer is false" do
    Fathom.config.uses_sqlite_optimizer = false
    @cpt.should_not_receive(:insert_hashes_into_table)
    @cpt.fill_table!
  end
  
end

