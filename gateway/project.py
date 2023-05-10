import sys
import time
import random
from Adafruit_IO import MQTTClient
import serial.tools.list_ports

AIO_FEED_BUTTON = "button1"

AIO_FEED_PUB_TEMP = "sensor3"
AIO_FEED_PUB_HUMIDITY = "sensor4"
AIO_FEED_PUB_LIGHT = "sensor1"
AIO_FEED_PUB_PROXIMITY = "sensor2"

AIO_USERNAME = "quangviet"
AIO_KEY = "aio_OMGE05PPsNTa0waG2mNwStvtN8Xz"

def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "USB Serial" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    return commPort


def connected(client):
    print("Ket noi thanh cong ...")
    client.subscribe(AIO_FEED_BUTTON)

def subscribe(client , userdata , mid , granted_qos):
    print("Subscribe thanh cong ...")

def disconnected(client):
    print("Ngat ket noi ...")
    sys.exit (1)

def message(client , feed_id , payload):
    if feed_id == AIO_FEED_BUTTON:
        print(payload)
        ser.write(payload.encode())
    # print("Nhan du lieu: " + payload + "id: " + feed_id)

client = MQTTClient(AIO_USERNAME , AIO_KEY)
client.on_connect = connected
client.on_disconnect = disconnected
client.on_message = message
client.on_subscribe = subscribe
client.connect()
client.loop_background()

portName = getPort()
portName = getPort()
print(portName)
if portName != "None":
    ser =serial.Serial(port = portName, baudrate = 115200)

count = 0
while True:
    data = ser.readline().strip().decode().split(":")
    if data[0] == 'L':
        client.publish(AIO_FEED_PUB_LIGHT, data[1])
    elif data[0] == 'P':        
        client.publish(AIO_FEED_PUB_PROXIMITY, data[1])
    elif data[0] == 'T':        
        client.publish(AIO_FEED_PUB_TEMP, data[1])
    elif data[0] == 'H':        
        client.publish(AIO_FEED_PUB_HUMIDITY, data[1])
    print(data)
ser.close()



#     client.publish(AIO_FEED_PUB[channel], random.randint(0,100))
#     channel = channel + 1
#     counter = 0

# if channel >= max_channel:
# 	channel = 0

# time.sleep(1)