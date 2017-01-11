//
//  OBAPushManager.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/10/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

#import "OBAPushManager.h"

NSString * const OBAPushNotificationUserIdDefaultsKey = @"OBAPushNotificationUserIdDefaultsKey";
NSString * const OBAPushNotificationPushTokenDefaultsKey = @"OBAPushNotificationPushTokenDefaultsKey";

@implementation OBAPushManager {
    PMKResolver resolver;
}

#pragma mark - Setup Stuff

+ (instancetype)pushManager {

    static OBAPushManager *pushManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pushManager = [[OBAPushManager alloc] init];
    });
    return pushManager;
}

- (void)startWithLaunchOptions:(NSDictionary*)launchOptions APIKey:(NSString*)APIKey {

    [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
        [self.class storeUserID:userId pushToken:pushToken];
        if (self->resolver) {
            self->resolver(userId);
        }
    }];

    [OneSignal initWithLaunchOptions:launchOptions appId:APIKey handleNotificationAction:^(OSNotificationOpenedResult *result) {

        // TODO!

    } settings:@{kOSSettingsKeyAutoPrompt: @(NO)}];
}

#pragma mark - Promises

- (AnyPromise*)requestUserPushNotificationID {
    AnyPromise *promise = [[AnyPromise alloc] initWithResolver:&resolver];

    NSString *pushUserID = self.pushNotificationUserID;
    if (pushUserID) {
        resolver(pushUserID);
    }
    else {
        [OneSignal registerForPushNotifications];
    }

    return promise;
}

#pragma mark - User Identity Tokens

+ (void)storeUserID:(NSString*)userID pushToken:(NSString*)pushToken {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:OBAPushNotificationUserIdDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:OBAPushNotificationPushTokenDefaultsKey];
}

- (NSString*)pushNotificationUserID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:OBAPushNotificationUserIdDefaultsKey];
}

- (NSString*)pushNotificationToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:OBAPushNotificationPushTokenDefaultsKey];
}


@end
