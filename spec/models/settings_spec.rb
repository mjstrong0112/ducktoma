require 'spec_helper'

describe Settings do

  it "has one instance that is persisted automatically" do
    Settings.instance.should be_persisted
  end

  context "with existing settings" do

    before :each do
      Settings.delete_all
      @attrs = {:adoptions_live => true, :duck_inventory => 55}
      Settings.instance.update_attributes(@attrs)
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

    #it "has static attribute readers" do
    #  @attrs.each_pair do |k, v|
    #    Settings[k].should == v
    #    Settings.read_attribute(k).should == v
    #  end
    #end

    # TODO: Reimplement
    #it "does not persist attribute changes automatically" do
    #  Settings.instance.changed?.should be false
    #  Settings.instance.adoptions_live = "thisischanged"
    #  Settings.instance.changed?.should be true
    #  Settings.save.should be true
    #  Settings.instance.changed?.should be false
    #end

    #it "returns same value with symbol or string as key" do
    #  Settings.instance["duck_inventory"].should == 123
    #
    #  Settings.instance["duck_inventory"] = 123
    #  Settings[:duck_inventory].should == 123
    #end
    
  end
end