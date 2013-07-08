require 'pi_piper'

module Pi_gpio

  class Gpio
    include PiPiper

    def initialize
      replace_port
    end

    def set_port(port, direction = :out, swich = :off)
      pin = PiPiper::Pin.new(:pin => port, :direction => direction)
      pin.send(swich)
    end

    def replace_port
      pins = []
      pins.each do |pin|
        pin = PiPiper::Pin.new(:pin => pin, :direction => :out)
        pin.off
      end
    end

    def read_port_status
      pins = []
      pins_info = {}
      pins.each do |pin|
        watch :pin => pin { pins_info[pin] = value}
      end
      return pins_info
    end

  end

end