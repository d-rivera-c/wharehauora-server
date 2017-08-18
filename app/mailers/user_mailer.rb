class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def offline_sensor_email(user, homename, roomname)
    @user = user
    @homename = homename
    @roomname = roomname
    mail(to: user.email, subject: "Offline Sensor in #{homename}, #{roomname}")
  end
end
