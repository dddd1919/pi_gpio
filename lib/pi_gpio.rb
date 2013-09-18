# encoding: utf-8
require 'pi_piper'
require 'net/http'
require 'uri'

module Pi_gpio

  class Gpio
    include PiPiper

    def initialize(pin_info)
      @pin_info = pin_info
      @pin_obj = {}
      @pin_watch_thread = {}
      replace_port
    end

    def set_port(port, direction = :out, switch = :off)
      @pin_obj[port] ||= PiPiper::Pin.new(:pin => port.split[1], :direction => direction)
      if @pin_obj[port].direction != direction
        @pin_obj[port] = PiPiper::Pin.new(:pin => port.split[1], :direction => direction)
      end
      @pin_obj[port].send(switch) if direction == :out
    end

    def replace_port
      ## 重置所有针脚到输出低电平，同时保存每个针脚创建的对象
      result = {}
      @pin_info.each do |num, info|
        if !info["name"].match(/GPIO \w+/).nil?
          pin_obj = PiPiper::Pin.new(:pin => "#{info["name"].split.last}", :direction => :out)
          @pin_obj[info["name"]] = pin_obj
          status = pin_obj.off
          result[num] = status
        end
      end
      return result
    end

    def read_port_status
      pins_status = {}
      @pin_info.each do |num, info|
        pins_status[num] = {}
        pins_status[num].merge!(name:info["name"])
        if !info["name"].match(/GPIO \w+/).nil?
          pin = @pin_obj[info["name"]]
          pins_status[num].merge!(io:pin.direction)
          btn_text = (pin.read == 1 ? "高电位" : "低电位")
          pins_status[num].merge!(btn_text:btn_text)
        else
          pins_status[num].merge!(io:info["io"])
          pins_status[num].merge!(btn_text:info["btn_text"])
          pins_status[num].merge!(btn_style:info["btn_style"])
        end
      end
      return pins_status
    end

    def watch_pin(pin)
      retval  = false
      new_watch_thread = watch :pin => pin do
        ## post pin changing message to faye server
        params = {}
        uri = URI.parse("http://localhost:3000/faye")
        params["message"] = {"channel" => "/messages/new", "data" => {"pin" => pin, "switch" => SWITCH[value]}}.to_json
        response = Net::HTTP.post_form(uri, params)
        retval = JSON.parse(response.body)[0]["successful"]
      end
      ## save thread message to PIN_WATCH_THREAD
      @pin_watch_thread[pin] = new_watch_thread
      return retval
    end

    def unwatch_pin(pin)
      retval = false
      if @pin_watch_thread[pin].nil?
        retval = true
      else
        @pin_watch_thread[pin].kill ## kill watch thread
        retval = !@pin_watch_thread.delete(pin).nil?
      end
      return retval
    end

  end
end
