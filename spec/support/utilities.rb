include ApplicationHelper

def clicar_submit
	click_button "Acceder"
end

def sign_in(user)
	visit signin_path
	fill_in "Email",    with: user.email
	fill_in "Password", with: user.password
	clicar_submit  
	# Sign in when not using Capybara as well.
	cookies[:remember_token] = user.remember_token
end


=begin
def full_title(page_title)
		base_title = "SocialWin Analytics"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
=end

