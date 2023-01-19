import logging
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json
from mqtt_config import *
import paho.mqtt.client as mqtt

logging.basicConfig(filename="send_to_firebase.log",
                    format="%(asctime)s %(message)s", filemode='w')
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


cred = credentials.Certificate(
    'elfaa-2023-firebase-adminsdk-qvq55-a3ee83af25.json')

default_app = firebase_admin.initialize_app(
    cred, {'databaseURL': "https://elfaa-2023-default-rtdb.asia-southeast1.firebasedatabase.app"})


# with open("book_info.json", "r") as f:
#     file_contents = json.load(f)

# ref.set(file_contents)


def on_connect(client, userdata, flags, rc):
    result_from_connect = mqtt.connack_string(rc)
    print("Result from connect: {}".format(result_from_connect))
    logger.debug("Result from connect: {}".format(result_from_connect))
    client.subscribe(mqtt_sub_topic)


def on_subscribe(client, userdata, mid, granted_qos):
    print("I've subscribe with QoS: {}".format(granted_qos[0]))
    logger.debug("I've subscribe with QoS: {}".format(granted_qos[0]))


def on_message(client, userdata, msg):
    topic = msg.topic
    m_decode = str(msg.payload.decode("utf-8", "ignore"))
    try:
        message_json = json.loads(m_decode)
        print("Message Received: ")
        print(message_json)
        logger.debug("Message Received: ")
        logger.debug(message_json)
        deviceID = message_json["deviceID"]
        lat = message_json["lat"]
        lng = message_json["lng"]
        timestamp = message_json["timestamp"]

        print("\n DeviceID: {}\n lat: {}\n lng: {}\n timestamp: {}\n".format(
            deviceID, lat, lng, timestamp))
        logger.debug("\n DeviceID: {}\n lat: {}\n lng: {}\n timestamp: {}\n".format(
            deviceID, lat, lng, timestamp))
        path = "/{}".format(deviceID)
        ref = db.reference(path)
        ref.set(message_json)
    except:
        print("Error message format")
    # print("Topic: {}".format(topic))
    # print("Message: {}".format(m_decode))


if __name__ == "__main__":
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_subscribe = on_subscribe
    client.on_message = on_message
    client.username_pw_set(mqtt_username, mqtt_password)
    client.connect(host=mqtt_server_host, port=mqtt_server_port,
                   keepalive=mqtt_keepalive)
    client.loop_forever()
