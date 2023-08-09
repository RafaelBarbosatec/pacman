import "dart:async";
import "dart:convert";

import "package:bonfire/state_manager/bonfire_injector.dart";
import "package:flutter/foundation.dart";
import "package:mqtt_client/mqtt_client.dart";
import "package:mqtt_client/mqtt_server_client.dart";
import "package:avnetman/util/game_state.dart";


const mqttServer = "127.0.0.1";

final MqttService mqttService = MqttService(mqttServer);

typedef FutureGenerator = Future Function();
Future retry_mqtt_connect(FutureGenerator aFuture, {Duration delay = const Duration(seconds: 5)}) async {
  try {
    return await aFuture();
  } catch (e) {
    await Future.delayed(delay);
    debugPrint("MQTT::Retry once more");
    return retry_mqtt_connect(aFuture, delay: delay);
  }
}

class MqttService {
  final MqttServerClient client;
  final String ip;

  bool isConnected = false;
  bool isIOTConnected = false;

  MqttService(this.ip) : client = MqttServerClient(ip, ip);

  final GameState gameState = BonfireInjector.instance.get();

  Future start() async {
    client.logging(on: false);

    client.setProtocolV311();

    client.keepAlivePeriod = 20;
    client.autoReconnect = true;

    client.onConnected = () async {
      isConnected = true;
      debugPrint("MQTT::Connected");

      client.published?.listen((MqttPublishMessage message) {
        debugPrint(
            "MQTT::Published: ${message.variableHeader!.topicName} ${message.payload.message}");
      });

    };

    client.onAutoReconnect = () {
      debugPrint("MQTT::AutoReconnect");
      isConnected = false;
    };

    client.onDisconnected = () {
      debugPrint("MQTT::Disconnected");
      isConnected = false;
    };

    retry_mqtt_connect(client.connect);

    return 0;
  }

  Future disconnect() async {
    await MqttUtilities.asyncSleep(2);
    debugPrint("MQTT::Disconnecting");
    client.disconnect();
    debugPrint("MQTT::Exiting normally");
  }

  void _publish(String topic, [String? value]) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      if (value != null) {
        builder.addString(value.toString());
      }

      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void publishWin() {
    _publish('printer/job', json.encode({ 'score': gameState.score }) );
  }

  void publishLottery() {
    _publish('cardreader/activate', '1');
  }
}