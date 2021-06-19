package com.haisbzaman.locationapp.untitled

import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate();
        BackgroundFetchPlugin.setPluginRegistrant(this);
    }

    override fun registerWith(registry: PluginRegistry?) {
        registry?.registrarFor("com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin");
    }

}