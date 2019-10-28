//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <cipher2/Cipher2Plugin.h>
#import <cloud_firestore/CloudFirestorePlugin.h>
#import <drawerbehavior/DrawerbehaviorPlugin.h>
#import <firebase_core/FirebaseCorePlugin.h>
#import <image_picker_saver/ImagePickerSaverPlugin.h>
#import <local_auth/LocalAuthPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <vibrate/VibratePlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [Cipher2Plugin registerWithRegistrar:[registry registrarForPlugin:@"Cipher2Plugin"]];
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [DrawerbehaviorPlugin registerWithRegistrar:[registry registrarForPlugin:@"DrawerbehaviorPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTImagePickerSaverPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerSaverPlugin"]];
  [FLTLocalAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTLocalAuthPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [VibratePlugin registerWithRegistrar:[registry registrarForPlugin:@"VibratePlugin"]];
}

@end
