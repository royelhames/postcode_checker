require 'test_helper'
class PostcodeTest < ActiveSupport::TestCase
  
  
  test "need postcode" do
    @p = Postcode.new("")
    assert true if @p.message == 'Postcode not valid'
  end
  
  test "valid postcode" do
    @random_postcodes = Array.new
    @random_postcodes = ['SH24 1AA','SH24 1AB','CV470EA','CT51JP','UB34JB','UB83UQ']
    @failed = 0
    @msgs = Array.new
    @random_postcodes.each do |pcode|
      @p = Postcode.new(pcode)
      #puts "#{pcode} status is " + @p.status.to_s
      if @p.status == 1
        next
      else
        @failed = 1
        @msgs.push("#{pcode}:#{@p.message}")
      end
    end
    if @failed == 1
      assert_not(0,@msgs.to_s)
    elsif @failed == 0
      assert true
    end  
  end

  test "invalid postcodes" do
    @random_postcodes = Array.new
    @random_postcodes = ['SH24 P1AC','CV470EAPC','CT5 1JPND','UB354JBC','UB83UQQ']
    @failed = 0
    @msgs = Array.new
    @random_postcodes.each do |pcode|
      @p = Postcode.new(pcode)
      if @p.status == 1
        next
      else
        @failed = 1
        @msgs.push("#{pcode}:#{@p.message}")
      end
    end
    
    if @failed == 1
      assert true
    elsif @failed == 0
      assert_not true
    end  
  end
  
  test "whitelisted postcodes" do
    @random_postcodes = Array.new
    @random_postcodes = ['SH24 1AA','SH24 1AB','SE1 7QD','SE1 7QA']
    @failed = 0
    @msgs = Array.new
    @random_postcodes.each do |pcode|
      @p = Postcode.new(pcode)
      if @p.whitelisted == 1
        next
      else
        @failed = 1
        @msgs.push("#{pcode}:#{@p.message}")
      end
    end
    
    if @failed == 1
      assert_not(0,@msgs.to_s)
    elsif @failed == 0
      assert true
    end  
  end
    
  
  
end
