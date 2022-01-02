class ContactsController < InheritedResources::Base


  # POST /categories or /categories.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { 
          flash[:notice] =  "Contact was successfully created." 
          redirect_to root_path
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :body)
    end

end
