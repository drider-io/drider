namespace :fb_profile do
  desc "Set Facebook profile settings"
  task set: :environment do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: 'Знайду хто підвезе або знайду попутчика'
      },
    })

    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'new_thread',
      call_to_actions: [
        {
          payload: 'welcome'
        }
      ]
    })


    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'existing_thread',
      call_to_actions: [
        {
          type: 'postback',
          title: 'Я водій',
          payload: 'select_driver'
        },
        {
          type: 'postback',
          title: 'Я пасажир',
          payload: 'select_rider'
        }
      ]
    })
  end
  # curl -X POST -H "Content-Type: application/json" -d '{
  #   "whitelisted_domains":[
  #     "https://.ngrok.io"
  #   ]
  # }' "https://graph.facebook.com/v2.6/me/messenger_profile?access_token="
end
