require 'sinatra'
require 'sinatra-websocket'
require "rubygems"
require "json"
require 'timers'

set :port => 4443
set :bind => '0.0.0.0'
set :sockets, []
set :public_foler, 'public'

class A

  def initialize(ws)
    @ws = ws
  end

  def sendPing()
    result = {"type": "ping"}
    result = result.to_json
    puts result
    @ws.send(result);
  end
end

get '/ws' do
  headers 'Access-Control-Allow-Origin' => '*'
  headers "Access-Control-Allow-Headers" => "*"
  puts "params: #{params}"

  if (request.websocket?)
    request.websocket do |ws|
      ws.onopen do
        puts "client connected"
        settings.sockets << ws
#a =  A.new(ws)
#timers = Timers::Group.new
#
#timers.every( 1 ) do
#  a.sendPing
#end
#loop { timers.wait }


      end
      ws.onmessage do |msg_json|
        msg = JSON.parse(msg_json)
        if msg['type'] == 'ping'
	  puts "receive: #{msg}"
          result = {"type": "pong"}
          result = result.to_json
          puts result
          ws.send(result);

        elsif msg['type'] == 'queryGame'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/query_game_win.json'))
         # result['last']['symbols']['line'] = []
         # 3.times do |i|
         #   line = []
         #   5.times do |j|
         #     line << rand(12) + 1
         #   end
         #   l = line.join("-")
         #   result['last']['symbols']['line'] << l
         # end
          result = result.to_json
          puts result
          ws.send(result);

        elsif msg['type'] == 'bet'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/bet.json'))
          result = result.to_json
          puts result
          ws.send(result);
        elsif  msg['type'] == 'spin'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/spin.json'))
          result = result.to_json
          puts result
          ws.send(result);
        elsif  msg['type'] == 'pick'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/pick.json'))
          result = result.to_json
          puts result
          ws.send(result);
	elsif  msg['type'] == 'takeWin'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/takewin.json'))
          result = result.to_json
          puts result
          ws.send(result);
	elsif  msg['type'] == 'enterGamble'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/enterGamble.json'))
          result = result.to_json
          puts result
          ws.send(result);
	elsif  msg['type'] == 'gambleBet'
          puts "receive: #{msg}"
          result = JSON.load(File.read('public/gambleBet.json'))
          result = result.to_json
          puts result
          ws.send(result);
	end 
      end
      #loop = EM.add_periodic_timer(5) { settings.sockets.each { |s| s.send({"queryGame": {"state": "baseGame", "lastGame": {"endGame": {"symbols": {lines: ["-1--1--1--1--1"]}}}}}.to_json) } }
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
        EM.cancel_timer(loop)
      end
    end
  else
    "hello"
  end
end
