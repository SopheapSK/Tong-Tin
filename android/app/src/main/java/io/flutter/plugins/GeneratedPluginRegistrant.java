package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.shyandsy.cipher2.Cipher2Plugin;
import io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin;
import com.infideap.drawerbehavior.DrawerbehaviorPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin;
import io.flutter.plugins.localauth.LocalAuthPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import flutter.plugins.vibrate.VibratePlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    Cipher2Plugin.registerWith(registry.registrarFor("com.shyandsy.cipher2.Cipher2Plugin"));
    CloudFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
    DrawerbehaviorPlugin.registerWith(registry.registrarFor("com.infideap.drawerbehavior.DrawerbehaviorPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    ImagePickerSaverPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin"));
    LocalAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.localauth.LocalAuthPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    VibratePlugin.registerWith(registry.registrarFor("flutter.plugins.vibrate.VibratePlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
