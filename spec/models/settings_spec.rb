require 'spec_helper'

describe Settings do
  it "is a singleton" do
    Settings.should include Singleton
  end
  it "has one instance that is persisted automatically" do
    Settings.instance.should be_persisted
  end
  context "with existing settings" do
    before :each do
      Settings.delete_all
      @attrs = {:first_setting => "test", :another_setting => "setting",
                                 :allow_test => true, :settings_count => 4}
      Settings.write_attributes(@attrs)
      Settings.save
    end
    it "has corresponding accessors" do
      settings = Settings.instance
      @attrs.each_pair do |k, v|
        settings.send(k).should == v
      end
    end
    it "has attribute readers" do
      @attrs.each_pair do |k, v|
        Settings.instance[k].should == v
        Settings.instance.read_attribute(k).should == v
      end
    end
    it "has static attribute readers" do
      @attrs.each_pair do |k, v|
        Settings[k].should == v
        Settings.read_attribute(k).should == v
      end
    end
    it "has static attribute writers" do
      Settings[:first_setting].should == "test"
      Settings.write_attribute(:first_setting, "testchanged")
      Settings[:first_setting].should == "testchanged"
      Settings[:another_setting].should == "setting"
      Settings[:another_setting] = "settingchanged"
      Settings[:another_setting].should == "settingchanged"
    end
    it "does not persist attribute changes automatically" do
      Settings.changed?.should be false
      Settings[:first_setting] = "thisischanged"
      Settings.changed?.should be true
      Settings.save.should be true
      Settings.changed?.should be false
    end
    it "returns same value with symbol or string as key" do
      Settings[:symbol_setting] = "Symbol Value"
      Settings["symbol_setting"].should == "Symbol Value"
      Settings["string_setting"] = "String Value"
      Settings[:string_setting].should == "String Value"
    end
  end
end