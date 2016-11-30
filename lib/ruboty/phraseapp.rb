require 'phraseapp-ruby'

module Ruboty
  module Handlers
    class Trello < Base
      on /phraseapp\sstats\slocale\s(?<locale_id>.*?)\z/, name: 'stats_locale', description: 'Show the stats of specified locale'

      def stats_locale(message)
        client = PhraseApp::Client.new(PhraseApp::Auth::Credentials.new(token: ENV['PHRASEAPP_ACCESS_TOKEN']))
        data = client.locale_show(ENV['PHRASEAPP_PROJECT_ID'], message[:locale_id]).first

        country = data.code.split('-').last
        untranslated = data.statistics['keys_untranslated_count']
        unverified = data.statistics['translations_unverified_count']

        reply_message = [
          "#{data.name}(#{data.code}):flag-#{country}: translation stats",
          "unverified: #{unverified} #{unverified > 0 ? ':warning:' : ':ok_hand:'}",
          "untranslated: #{untranslated} #{unverified > 0 ? ':warning:' : ':ok_hand:'}"
        ]

        message.reply reply_message.join("\n")
      end
    end
  end
end
