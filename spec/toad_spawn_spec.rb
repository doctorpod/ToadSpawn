require 'toad_spawn/base'
require File.dirname(__FILE__) + '/helper'

describe ToadSpawn::Base do
  before(:each) do
    reset_sandbox
  end
  
  describe "Path validation" do
    it "Raise error if directory absent" do
      lambda { ToadSpawn::Base.new('does/not/exist') } .should raise_error 'Directory does not exist'
    end
    
    it "Raise error if not a directory" do
      lambda { ToadSpawn::Base.new(fixtures('afile.txt')) } .should raise_error 'Not a directory'
    end
    
    it "Raise error if not writable" do
      lambda { ToadSpawn::Base.new('/bin') } .should raise_error 'Not writable'
    end
  end
  
  describe "Setting and reading data" do
    before(:each) do
      @db_folder = sandbox('spawn')
      system "mkdir #{@db_folder}"
      @data = ToadSpawn::Base.new(@db_folder)
    end
    
    it "#key_file_path" do
      @data.key_file_path(:foobar).should == File.join(@db_folder, 'foobar.value')
    end
    
    it "returns nil if key does not exist" do
      @data[:aardvarks] == nil
    end
    
    it "set and read string" do
      @data[:foo] = 'bar'
      @data[:foo].should == 'bar'
    end

    it "set and read complex string" do
      @data[:long] = File.read(fixtures('long.txt'))
      @data[:long].should == File.read(fixtures('long.txt'))
    end

    it "set and read Fixnum" do
      @data[:fixnum] = 1001
      @data[:fixnum].should == 1001
    end

    it "set and read Float" do
      @data[:fixnum] = 1.2345
      @data[:fixnum].should == 1.2345
    end
  end
  
  describe "Persistence" do
    before(:each) do
      @folder = sandbox
      @first = ToadSpawn::Base.new(@folder)
      @first[:foo] = 'bam'
      @first[:bar] = 22.2
    end
    
    it "second should be same data as first" do      
      second = ToadSpawn::Base.new(@folder)
      second[:foo].should == 'bam'
      second[:bar].should == 22.2
    end
    
    it "changes in first should be reflected in second" do
      @first.delete(:foo)
      second = ToadSpawn::Base.new(@folder)
      second[:foo].should == nil
    end
    
    describe "flushing" do
      it "should see same data when flushed" do
        second = ToadSpawn::Base.new(@folder)
        second.size.should == 2
        @first.delete(:foo)
        second.size.should == 2
        second.flush
        second.size.should == 1
      end
    end
  end
  
  describe "Data functions" do
    before(:each) do
      reset_sandbox
      @folder1 = sandbox('1')
      @folder2 = sandbox('2')
      Dir.mkdir @folder1
      Dir.mkdir @folder2
      @data = ToadSpawn::Base.new(@folder1)
      @data[:one]   = 'a'
      @data[:two]   = 2
      @data[:three] = 0.3
    end
    
    describe "#to_hash" do
      it "should return a hash" do
        @data.to_hash.should == {:one => 'a', :two => 2, :three => 0.3}
      end
    end
    
    describe "#empty?" do
      it "should deem it empty" do
        ToadSpawn::Base.new(@folder2).empty?.should be_true
      end
      
      it "should deem it not empty" do
        @data.empty?.should be_false
      end
    end

    describe "#any?" do
      it "should deem it empty" do
        ToadSpawn::Base.new(@folder2).any?.should be_false
      end
      
      it "should deem it not empty" do
        @data.any?.should be_true
      end
    end
    
    describe "#has_key?" do
      it "should find the key" do
        @data.has_key?(:three).should be_true
      end

      it "should not find the key" do
        @data.has_key?(:boomerangs).should be_false
      end
    end
    
    describe "#has_value?" do
      it "should find the value" do
        @data.has_value?(2).should be_true
      end

      it "should not find the value" do
        @data.has_value?('some aardvarks').should be_false
      end
    end
    
    describe "#keys" do
      it "should return keys as array" do
        keys = @data.keys
        keys.class.should == Array
        keys.size.should == 3
        keys.include?(:one).should be_true
        keys.include?(:two).should be_true
        keys.include?(:three).should be_true
      end
    end
    
    describe "#values" do
      it "should return values as array" do
        vals = @data.values
        vals.class.should == Array
        vals.size.should == 3
        vals.include?('a').should be_true
        vals.include?(2).should be_true
        vals.include?(0.3).should be_true
      end
    end
    
    describe "#size" do
      it "should measure a full" do
        @data.size.should == 3
      end

      it "should measure a zero" do
        ToadSpawn::Base.new(@folder2).size.should == 0
      end
    end
    
    describe "#delete" do
      it "should delete an element" do
        @data.delete(:three)
        @data[:three].should be_nil
        @data.size.should == 2
      end
      
      it "should return deleted element" do
        @data.delete(:two).should == 2
      end
    end
    
    describe "#clear" do
      it "should delete all elements" do
        @data.clear
        @data.size.should == 0
      end
    end
  end
end