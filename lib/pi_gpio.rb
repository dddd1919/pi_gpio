# encoding: utf-8
require 'pi_piper'

module Pi_gpio

  class Gpio
    include PiPiper

    def initialize(pin_info)
      @pin_info = pin_info
      replace_port
    end

    def set_port(port, direction = :out, swich = :off)
      pin = PiPiper::Pin.new(:pin => port, :direction => direction)
      pin.send(swich)
    end

    def replace_port
      result = {}
      @pin_info.each do |num, info|
        if !info["name"].match(/GPIO \s/).nil?
          pin = PiPiper::Pin.new(:pin => "#{info["name"].split.last}", :direction => :out)
          status = pin.off
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
        if !info["name"].match(/GPIO \s/).nil?
          pin = PiPiper::Pin.new(:pin => "#{info["name"].split.last}")
          pins_status[num].merge!(io:pin.direction)
          btn_text = (pin.value == 1 ? "高电位" : "低电位")
          pins_status[num].merge!(btn_text:btn_text)
        else
          pins_status[num].merge!(io:info["io"])
          pins_status[num].merge!(btn_text:info["btn_text"])
        end
      end
      return pins_status
    end

  end
end
