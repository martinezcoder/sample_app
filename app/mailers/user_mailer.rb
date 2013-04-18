class UserMailer < ActionMailer::Base
  default :from => "info@socialwin.es" 

  def registration_confirmation(user)  
    mail(:to => user.email, :subject => "Registrado")  
  end

  def notification(user)  
    mail(:to => user.email, :subject => "Newsletter", :from => "martinezcoder@gmail.com")  
  end


end
