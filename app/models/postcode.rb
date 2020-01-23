class Postcode
  
  
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  
  attr_accessor :postcode
  attr_accessor :whitelisted
  attr_accessor :status
  attr_accessor :message
  
  
  def initialize(postcode)
    @postcode = postcode
    @status   = status
    @whitelisted = whitelisted
    @message  = message
  end

  def status
    @status = 1
    if @postcode == "SH24 1AA" or @postcode == "SH24 1AB"
      return @status
    end
    
    if @postcode.to_s =~ /^\s*((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))\s*$/i
      @status = 1
    else
      @status = 2
    end
    return @status
  end
  
  def message
    @message = ''
    if @status == 2
      @message = "Postcode not valid"
    elsif @status == 3 or @whitelisted == 0
      @message = "Postcode not recognised or whitelisted by http://postcodes.io"
    elsif @whitelisted == 1
      @message = "Postcode is servable"
    end 
  end
  
  def whitelisted
    return unless @status == 1
    if @postcode.to_s.gsub(/\s+/,"") == "SH241AA" or @postcode.to_s.gsub(/\s+/,"") == "SH24 1AB"
      @whitelisted = 1
      return @whitelisted
    end
    require 'net/http'
    uri = URI.parse("http://postcodes.io/postcodes/#{@postcode.gsub(/\s+/,'')}") 
    @response = Net::HTTP.get_response(uri)
    @encoded = JSON.parse(@response.body)
    if @encoded["status"] == 200
      @lsoa = @encoded["result"]["lsoa"]
      if @lsoa.match(/Southwark|Lambeth/i)
        @whitelisted = 1
      else
        @whitelisted = 0
      end  
    else
      @status = 3
      @whitelisted = 0
    end
    return @whitelisted
  end  
  
end