class PushNotificationService
  require 'fcm'

  def initialize
    @fcm = FCM.new(FCM_SERVER_KEY)
  end

  def send_notification(device_token, title, body)
    options = {
      priority: 'high',
      notification: {
        title: title,
        body: body,
        sound: 'default'
      }
    }

    response = @fcm.send([device_token], options)
    response
  end
end
