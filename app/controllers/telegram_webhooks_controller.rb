class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ActionView::Helpers::DateHelper
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def register(*args)
    if args.any?
      email_address = args.join(' ')
      puts email_address
      if(user = User.find_by :email => email_address)
        puts user.email
        puts chat
        puts from
        bot.send_message chat_id: from["id"], text: 'user registered'
        #user.settings.telegramId = from["id"]
        user.telegramId = from["id"]
        user.save
        puts user.telegramId
      else
        respond_with :message, text: "user not found"
      end
    else
      respond_with :message, text: "send /register email@example.com"
    end
  end

  def list(*)
    user = User.find_by :telegramId => from["id"]
    if(user.blank?)
      respond_with :message, text: "You're not registered, please send /register email@example.com to register"
    else
      scrapes = user.scrapes
      scrapes.each do |scrape|
        #bot.send_message chat_id: from["id"], text: "#{scrape.name} Status: #{scrape.status} Last Read: #{time_ago_in_words(scrape.last_read) if scrape.last_read } ago"
        #respond_with :message, text: '<b>bold</b>', parse_mode: :HTML
        respond_with :message, text:
        "Scrape: <b>#{scrape.name}</b> \nStatus: <b>#{scrape.status}</b> \nLast Read: <b>#{time_ago_in_words(scrape.last_read) if scrape.last_read } ago</b>", reply_markup: {
          inline_keyboard: [
            [{text: "Link", url: scrape.url}],
          ],
        }, parse_mode: :HTML
      end
    end
  end

  def start(*)
    respond_with :message, text: t('.content')
  end

  def help(*)
    respond_with :message, text: t('.content')
  end

  def memo(*args)
    if args.any?
      session[:memo] = args.join(' ')
      respond_with :message, text: t('.notice')
    else
      respond_with :message, text: t('.prompt')
      save_context :memo
    end
  end

  def remind_me
    to_remind = session.delete(:memo)
    reply = to_remind || t('.nothing')
    respond_with :message, text: reply
  end

  def keyboard(value = nil, *)
    if value
      respond_with :message, text: t('.selected', value: value)
    else
      save_context :keyboard
      respond_with :message, text: t('.prompt'), reply_markup: {
        keyboard: [t('.buttons')],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true,
      }
    end
  end

  def inline_keyboard
    respond_with :message, text: t('.prompt'), reply_markup: {
      inline_keyboard: [
        [
          {text: t('.alert'), callback_data: 'alert'},
          {text: t('.no_alert'), callback_data: 'no_alert'},
        ],
        [{text: t('.repo'), url: 'https://github.com/telegram-bot-rb/telegram-bot'}],
      ],
    }
  end

  def callback_query(data)
    if data == 'alert'
      answer_callback_query t('.alert'), show_alert: true
    else
      answer_callback_query t('.no_alert')
    end
  end

  def message(message)
    respond_with :message, text: t('.content', text: message['text'])
  end

  def inline_query(query, offset)
    query = query.first(10) # it's just an example, don't use large queries.
    t_description = t('.description')
    t_content = t('.content')
    results = 5.times.map do |i|
      {
        type: :article,
        title: "#{query}-#{i}",
        id: "#{query}-#{i}",
        description: "#{t_description} #{i}",
        input_message_content: {
          message_text: "#{t_content} #{i}",
        },
      }
    end
    answer_inline_query results
  end

  # As there is no chat id in such requests, we can not respond instantly.
  # So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
  def chosen_inline_result(result_id, query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: t('.selected', result_id: result_id)
    else
      respond_with :message, text: t('.prompt')
    end
  end

  def action_missing(action, *_args)
    if command?
      respond_with :message, text: t('telegram_webhooks.action_missing.command', command: action)
    else
      respond_with :message, text: t('telegram_webhooks.action_missing.feature', action: action)
    end
  end
end
