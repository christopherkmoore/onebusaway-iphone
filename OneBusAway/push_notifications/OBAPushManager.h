//
//  OBAPushManager.h
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/10/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

@import Foundation;
@import OneSignal;
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const OBAPushNotificationUserIdDefaultsKey;
extern NSString * const OBAPushNotificationPushTokenDefaultsKey;

@interface OBAPushManager : NSObject
@property(nonatomic,copy,readonly) NSString *pushNotificationUserID;
@property(nonatomic,copy,readonly) NSString *pushNotificationToken;

+ (instancetype)pushManager;

- (void)startWithLaunchOptions:(NSDictionary*)launchOptions APIKey:(NSString*)APIKey;

- (AnyPromise*)requestUserPushNotificationID;

@end

NS_ASSUME_NONNULL_END
