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

@implementation OBAPushManager

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
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:OBAPushNotificationUserIdDefaultsKey];
        [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:OBAPushNotificationPushTokenDefaultsKey];
    }];

    [OneSignal initWithLaunchOptions:launchOptions appId:APIKey handleNotificationAction:^(OSNotificationOpenedResult *result) {

        // TODO!

    } settings:@{kOSSettingsKeyAutoPrompt: @(NO)}];
}

#pragma mark - Promises

- (AnyPromise*)requestUserPushNotificationID {
    NSString *pushID = self.pushNotificationUserID;

    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        if (pushID) {
            resolve(pushID);
        }
        else {
            [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:OBAPushNotificationUserIdDefaultsKey];
                [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:OBAPushNotificationPushTokenDefaultsKey];
            }];
            [OneSignal registerForPushNotifications];
        }
//        [CLLocationManager until:^BOOL(CLLocation *location) {
//            iterations += 1;
//            if (iterations >= 5) {
//                return YES;
//            }
//            else {
//                return location.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters;
//            }
//        }].thenInBackground(^(CLLocation* currentLocation) {
//            MKPlacemark *sourcePlacemark = [self.class placemarkForCoordinate:currentLocation.coordinate];
//            MKPlacemark *destinationPlacemark = [self.class placemarkForCoordinate:destination];
//            MKDirections *directions = [self.class walkingDirectionsFrom:sourcePlacemark to:destinationPlacemark];
//            return [directions calculateETA];
//        }).then(^(MKETAResponse* ETA) {
//            resolve(ETA);
//        }).catch(^(NSError *error) {
//            resolve(error);
//        }).always(^{
//            iterations = 0;
//        });
    }];
}

#pragma mark - Public Properties

- (NSString*)pushNotificationUserID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:OBAPushNotificationUserIdDefaultsKey];
}

- (NSString*)pushNotificationToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:OBAPushNotificationPushTokenDefaultsKey];
}


@end
