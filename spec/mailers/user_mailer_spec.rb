require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) do
      FactoryGirl.create(:user).tap{|u| u.generate_token(:password_reset_token)}
    end
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      expect(mail.subject).to eql "[event_girl] Password reset"
      expect(mail.to).to eql [user.email]
      expect(mail.from).to eql [APP_CONFIG[:mail_from]]
    end

    it "renders the body" do
      url = edit_password_reset_url(
        user.password_reset_token,
        host: APP_CONFIG[:host],
        protocol: APP_CONFIG[:url_scheme]
      )
      mail.body.encoded.should match(url)
    end
  end
end
