require "lita"

module Lita
  module Handlers
    class Stocks < Handler
      route %r{^stock ([\w .-_]+)$}i, :stock_info, command: true, help: {
        "stock <symbol>" => "Returns stock price information about the provided stock symbol."
      }



      def stock_info(response)
        symbol = response.matches[0][0]
        data = get_stock_data(symbol)

        response.reply format_response(data)

      rescue Exception => e
        Lita.logger.error("Stock information error: #{e.message}")
        response.reply "Sorry, but there was a problem retrieving stock information."
      end

      private 


      def get_stock_data(symbol)
        resp = http.get("https://www.google.com/finance/info?infotype=infoquoteall&q=#{symbol}")
        raise 'RequestFail' unless resp.status == 200
        MultiJson.load(resp.body.gsub(/\/\//, ''))[0]
      end

      def format_response(data)
        "#{data['name']} (#{data['e']}:#{data['t']}) - #{data['l']} (#{data['c']}, #{data['cp']}%) - 52week high/low: (#{data['hi52']}/#{data['lo52']}) - MktCap: #{data['mc']} - P/E: #{data['pe']}"
      end


    end

    Lita.register_handler(Stocks)
  end
end