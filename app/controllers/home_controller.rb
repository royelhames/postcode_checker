class HomeController < ApplicationController
  
  def index
    
    if  params[:postcode] and params[:postcode][:postcode]
      @postcode = Postcode.new(params[:postcode][:postcode])
      logger.debug("postcode obh is " + @postcode.inspect)
      flash.now[:alert] = @postcode.message 
    end  
    
  end  
end
