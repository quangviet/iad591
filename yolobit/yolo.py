from yolobit import *
button_a.on_pressed = None
button_b.on_pressed = None
button_a.on_pressed_ab = button_b.on_pressed_ab = -1
from event_manager import *
import time
from aiot_rgbled import RGBLed
import sys
import uselect
from aiot_lcd1602 import LCD1602
from machine import Pin, SoftI2C
from aiot_dht20 import DHT20

event_manager.reset()

tiny_rgb = RGBLed(pin2.pin, 4)

def on_event_timer_callback_i_R_l_i_X():
  global light, cmd, humidity, temp, proximity
  light = round(translate((pin1.read_analog()), 0, 4095, 0, 100))
  if light < 20:
    tiny_rgb.show(0, hex_to_rgb('#00ff00'))
  else:
    tiny_rgb.show(0, hex_to_rgb('#000000'))

event_manager.add_timer_event(1000, on_event_timer_callback_i_R_l_i_X)

def read_terminal_input():
  spoll=uselect.poll()        # Set up an input polling object.
  spoll.register(sys.stdin, uselect.POLLIN)    # Register polling object.

  input = ''
  if spoll.poll(0):
    input = sys.stdin.read(1)

    while spoll.poll(0):
      input = input + sys.stdin.read(1)

  spoll.unregister(sys.stdin)
  return input

aiot_lcd1602 = LCD1602()

def on_event_timer_callback_b_Y_j_q_I():
  global light, cmd, humidity, temp, proximity
  cmd = read_terminal_input()
  if cmd == 'ON':
    aiot_lcd1602.backlight_on()
  elif cmd == 'OFF':
    aiot_lcd1602.backlight_off()

event_manager.add_timer_event(1000, on_event_timer_callback_b_Y_j_q_I)

aiot_dht20 = DHT20(SoftI2C(scl=Pin(22), sda=Pin(21)))

def on_event_timer_callback_T_e_X_r_b():
  global light, cmd, humidity, temp, proximity
  aiot_dht20.read_dht20()
  aiot_lcd1602.clear()
  humidity = aiot_dht20.dht20_humidity()
  temp = aiot_dht20.dht20_temperature()
  aiot_lcd1602.move_to(0, 0)
  aiot_lcd1602.putstr(('Nhiet do: ' + str(temp)))
  aiot_lcd1602.move_to(0, 1)
  aiot_lcd1602.putstr(('Do am: ' + str(humidity)))

event_manager.add_timer_event(5000, on_event_timer_callback_T_e_X_r_b)

def on_event_timer_callback_O_b_G_e_T():
  global light, cmd, humidity, temp, proximity
  if pin0.read_digital()==1:
    display.show(Image("00000:04440:04440:04440:00000"))
    proximity = 1
  else:
    display.show(Image("00000:00000:00000:00000:00000"))
    proximity = 0

event_manager.add_timer_event(1000, on_event_timer_callback_O_b_G_e_T)

def on_event_timer_callback_q_M_Z_c_V():
  global light, cmd, humidity, temp, proximity
  if humidity != -1 and light != -1 and temp != -1:
    print(('L:' + str(light)))
    print(('H:' + str(humidity)))
    print(('T:' + str(temp)))
    print(('P:' + str(proximity)))

event_manager.add_timer_event(10000, on_event_timer_callback_q_M_Z_c_V)

if True:
  display.scroll('Nhom 8')
  humidity = -1
  temp = -1
  light = -1
  proximity = 0

while True:
  event_manager.run()
  time.sleep_ms(100)
