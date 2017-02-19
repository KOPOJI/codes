class Recaptcha
  def self.verify(params)
    options = {
        body: {
            secret:   '6Le5IRYUAAAAAO2VYTOj_AsU66ulPFfSsTBRP1Aa',
            response: params['g-recaptcha-response'],
            remoteip: params[:remoteip]
        }
    }
    HTTParty.post 'https://www.google.com/recaptcha/api/siteverify', options
  end
end