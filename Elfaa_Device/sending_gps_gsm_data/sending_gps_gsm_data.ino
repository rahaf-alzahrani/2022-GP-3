#define TINY_GSM_MODEM_SIM800
#define SerialMon Serial

#define TINY_GSM_DEBUG SerialMon
#define GSM_PIN ""

#include <PubSubClient.h>
#include <TinyGsmClient.h>
#include <ArduinoJson.h>
#include <TimeLib.h>
#include <TinyGPSPlus.h>
#include "SoftwareSerial.h"
static const int RXPin = 26, TXPin = 27;
SoftwareSerial GSM_Serial(RXPin, TXPin);

#define DEVICE_ID "gps123id42"

const char apn[] = "jawalnet.com.sa";
const char gprsUser[] = "";
const char gprsPass[] = "";

// SIM card PIN
const char simPIN[] = "";

// MQTT details
const char* broker = "139.177.191.224";
const char* mqttUsername = "elfaa";
const char* mqttPassword = "123456";

const char* topicPubGpsData = "esp32/gsm_gps/device";
const char* topicSubLed = "esp32/gsm";



#ifdef DUMP_AT_COMMANDS
#include <StreamDebugger.h>
StreamDebugger debugger(SerialAT, SerialMon);
TinyGsm modem(debugger);
#else
TinyGsm modem(GSM_Serial);
#endif

TinyGsmClient client(modem);
PubSubClient mqtt(client);
TinyGPSPlus gps;


// ESP32 and SIM800l pins
#define MODEM_TX 26
#define MODEM_RX 27

uint32_t lastReconnectAttempt = 0;
long lastMsg = 0;
float lat = 0;
float lng = 0;
StaticJsonDocument<256> doc;
unsigned long timestamp;


void mqttCallback(char* topic, byte* message, unsigned int len) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");
  String messageTemp;

  for (int i = 0; i < len; i++) {
    Serial.print((char)message[i]);
    messageTemp += (char)message[i];
  }
  Serial.println();
}

boolean mqttConnect() {
  SerialMon.print("Connecting to ");
  SerialMon.print(broker);

  boolean status = mqtt.connect("GsmClientN", mqttUsername, mqttPassword);

  if (status == false) {
    SerialMon.println(" fail");
    ESP.restart();
    return false;
  }
  SerialMon.println(" success");
  mqtt.subscribe(topicSubLed);
  return mqtt.connected();
}

void setup() {
  SerialMon.begin(115200);
  Serial2.begin(9600);
  delay(1000);
  SerialMon.println("Wait ...");
  GSM_Serial.begin(9600);
  delay(3000);
  SerialMon.println("Initializing modem ...");
  modem.restart();

  String modemInfo = modem.getModemInfo();
  SerialMon.print("Modem Info: ");
  SerialMon.println(modemInfo);

  // Unlock your sim card with a PIN if needed
  if (GSM_PIN && modem.getSimStatus() != 3) {
    modem.simUnlock(GSM_PIN);
  }

  SerialMon.print("Connecting to APN: ");
  SerialMon.print(apn);
  if (!modem.gprsConnect(apn, gprsUser, gprsPass)) {
    SerialMon.println(" fail");
    ESP.restart();
  }
  SerialMon.println(" OK");
  if (modem.isGprsConnected()) {
    SerialMon.println("GPRS connected");
  }
  DBG("Asking modem to sync with NTP");
  modem.NTPServerSync("132.163.96.5", 20);

  // MQTT Broker setup
  mqtt.setServer(broker, 1883);
  mqtt.setCallback(mqttCallback);
}

void loop() {
  if (!mqtt.connected()) {
    SerialMon.println("=== MQTT NOT CONNECTED ===");
    // Reconnect every 10 seconds
    uint32_t t = millis();
    if (t - lastReconnectAttempt > 10000L) {
      lastReconnectAttempt = t;
      if (mqttConnect()) {
        lastReconnectAttempt = 0;

      }
    }
    delay(100);
    return;
  }

  long now = millis();
  if (now - lastMsg > 10000) {
    lastMsg = now;
    get_gps_data();

  }
  mqtt.loop();
}
void get_gps_data() {
  while (Serial2.available() > 0) {
    gps.encode(Serial2.read());
  }
  if (gps.location.isUpdated()) {
    lat = gps.location.lat();
    lng = gps.location.lng();
    Serial.print("Latitude = ");
    Serial.println(lat, 6);
    Serial.print("Longitude= ");
    Serial.print(lng, 6);
  }
  char buffer[256];

  timestamp = get_timestamp();
  doc["deviceID"] = DEVICE_ID;
  doc["lat"] = lat;
  doc["lng"] = lng;
  doc["timestamp"] = timestamp;

  SerialMon.print("Publish to broker: ");
  serializeJson(doc, SerialMon);
  SerialMon.println();
  serializeJson(doc, buffer);
  mqtt.publish(topicPubGpsData, buffer);
}

int get_timestamp() {
  int   year3    = 0;
  int   month3   = 0;
  int   day3     = 0;
  int   hour3    = 0;
  int   min3     = 0;
  int   sec3     = 0;
  float timezone = 0;
  for (int8_t i = 5; i; i--) {
    DBG("Requesting current network time");
    if (modem.getNetworkTime(&year3, &month3, &day3, &hour3, &min3, &sec3,
                             &timezone)) {
      DBG("Year:", year3, "\tMonth:", month3, "\tDay:", day3);
      DBG("Hour:", hour3, "\tMinute:", min3, "\tSecond:", sec3);
      DBG("Timezone:", timezone);
      break;
    } else {
      DBG("Couldn't get network time, retrying in 15s.");
      delay(15000L);
    }
  }

  setTime(hour3, min3, sec3, day3, month3, year3);
  SerialMon.print("Timestamp: ");
  int ct = now();
  SerialMon.println(ct);
  return ct;
}
