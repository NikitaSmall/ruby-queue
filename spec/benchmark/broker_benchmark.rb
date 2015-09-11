require File.join(File.dirname(__FILE__), '../spec_helper.rb')
require File.join(File.dirname(__FILE__), '../../lib/broker.rb')
require 'socket'
require 'benchmark'

def take_response_from_server(port)
  s = TCPSocket.open('localhost', port)

  response = ""
  while line = s.gets
      response += line
  end
  s.close
  response
end

def create_task(options)
  thr = Thread.new do
    create(:task, options)
  end
  thr.join
  thr.kill
end

describe Broker do
  before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  describe 'benchmark for one thread' do
    before(:each) do
      puts "One thread: \n"
    end

    it 'sends messages with 1000 tasks' do
      # creating tasks
      1000.times { |num| create_task channel: "channel_#{num}" }

      Benchmark.bm(26) do |bm|
        bm.report("1 thd, 1000 tasks sent:") do
          1000.times { take_response_from_server(PORT) }
        end
      end
    end

    it 'sends messages without tasks' do
      Benchmark.bm(26) do |bm|
        bm.report("1 thd, 1000 'none' sent:") do
          1000.times { take_response_from_server(PORT) }
        end
      end
    end
  end

  describe 'benchmark for few threads' do
    before(:each) do
      prng = Random.new
      @threads_num = prng.rand(2...8)

      puts "#{@threads_num} threads: \n"
    end

    it 'sends messages with 1000 tasks' do
      # creating tasks
      (1000).times { |num| create_task channel: "channel_#{num}" }

      Benchmark.bm(26) do |bm|
        bm.report("#{@threads_num} thds, 1000 tasks sent:") do
          @threads_num.times.map do
            Thread.new do
              (1000 / @threads_num).ceil.times { take_response_from_server(PORT) }
            end
          end.each(&:join)
        end
      end
    end

  end

  describe 'benchmark for 50 threads' do
    before(:each) do
      puts "50 threads: \n"
    end

    it 'sends messages with 1000 tasks' do
      # creating tasks
      1000.times { |num| create_task channel: "channel_#{num}" }

      Benchmark.bm(26) do |bm|
        bm.report("50 thds, 1000 tasks sent:") do
          50.times.map do
            Thread.new do
              20.times { take_response_from_server(PORT) }
            end
          end.each(&:join)
        end
      end
    end

  end

  describe 'benchmark for real situation' do
    it 'works' do
      (4000 * 2 * 4 * 10).times { |num| create_task channel: "channel_#{num}", argument: File.open(File.join(File.dirname(__FILE__), '../support/broker_start_serve_last_task.json')) }

      Benchmark.bm(26) do |bm|
        bm.report("10 thds for all the tasks sent:") do
          10.times.map do
            Thread.new do
              32000.times { take_response_from_server(PORT) }
            end
          end.each(&:join)
        end
      end
    end

  end
end
