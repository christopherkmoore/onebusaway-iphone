/**
 * Copyright (C) 2009 bdferris <bdferris@onebusaway.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <OBAKit/OBAModelDAOUserPreferencesImpl.h>
@import CoreLocation;
#import <OBAKit/OBAMacros.h>
#import <OBAKit/OBARegionV2.h>
#import <OBAKit/OBALogging.h>

NSString * const kBookmarksKey = @"bookmarks";
NSString * const kBookmarkGroupsKey = @"bookmarkGroups";
NSString * const kMostRecentStopsKey = @"mostRecentStops";
NSString * const kStopPreferencesKey = @"stopPreferences";
NSString * const kMostRecentLocationKey = @"mostRecentLocation";
NSString * const kHideFutureLocationWarningsKey = @"hideFutureLocationWarnings";
NSString * const kVisitedSituationIdsKey = @"visitedSituationIdsKey";
NSString * const kOBARegionKey = @"oBARegion";
NSString * const kCustomRegionsKey = @"customRegions";
NSString * const kSharedTripsKey = @"sharedTrips";
NSString * const kSetRegionAutomaticallyKey = @"setRegionAutomatically";
NSString * const kUngroupedBookmarksOpenKey = @"UngroupedBookmarksOpen";
NSString * const OBAShareRegionPIIUserDefaultsKey = @"OBAShareRegionPIIUserDefaultsKey";
NSString * const OBAShareLocationPIIUserDefaultsKey = @"OBAShareLocationPIIUserDefaultsKey";
NSString * const OBAShareLogsPIIUserDefaultsKey = @"OBAShareLogsPIIUserDefaultsKey";

@implementation OBAModelDAOUserPreferencesImpl
@dynamic shareRegionPII;
@dynamic shareLocationPII;
@dynamic shareLogsPII;

- (void)setUngroupedBookmarksOpen:(BOOL)ungroupedBookmarksOpen {
    [[NSUserDefaults standardUserDefaults] setBool:ungroupedBookmarksOpen forKey:kUngroupedBookmarksOpenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)ungroupedBookmarksOpen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUngroupedBookmarksOpenKey];
}

- (NSArray*)readBookmarks {
    return [self.class loadAndDecodeObjectFromDataForKey:kBookmarksKey] ?: @[];
}

- (void)writeBookmarks:(NSArray*)source {
    [self.class writeObjectToUserDefaults:source withKey:kBookmarksKey];
}

- (NSArray*)readBookmarkGroups {
    return [self.class loadAndDecodeObjectFromDataForKey:kBookmarkGroupsKey] ?: @[];
}

- (void)writeBookmarkGroups:(NSArray*)source {
    [self.class writeObjectToUserDefaults:source withKey:kBookmarkGroupsKey];
}

- (NSArray*)readMostRecentStops {
    return [self.class loadAndDecodeObjectFromDataForKey:kMostRecentStopsKey] ?: @[];
}

- (void)writeMostRecentStops:(NSArray*)source {
    [self.class writeObjectToUserDefaults:source withKey:kMostRecentStopsKey];
}

- (NSDictionary*)readStopPreferences {
    id out = [self.class loadAndDecodeObjectFromDataForKey:kStopPreferencesKey] ?: @{};
    return out;
}

- (void)writeStopPreferences:(NSDictionary*)stopPreferences {
    [self.class writeObjectToUserDefaults:stopPreferences withKey:kStopPreferencesKey];
}

- (CLLocation*)readMostRecentLocation {
    return [self.class loadAndDecodeObjectFromDataForKey:kMostRecentLocationKey];
}

- (void)writeMostRecentLocation:(CLLocation*)mostRecentLocation {
    [self.class writeObjectToUserDefaults:mostRecentLocation withKey:kMostRecentLocationKey];
}

- (BOOL)hideFutureLocationWarnings {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHideFutureLocationWarningsKey];
}

- (void)setHideFutureLocationWarnings:(BOOL)hideFutureLocationWarnings {
    [[NSUserDefaults standardUserDefaults] setBool:hideFutureLocationWarnings forKey:kHideFutureLocationWarningsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSSet*)readVisistedSituationIds {
    return [self.class loadAndDecodeObjectFromDataForKey:kVisitedSituationIdsKey] ?: [NSSet set];
}

- (void)writeVisistedSituationIds:(NSSet*)situationIds {
    [self.class writeObjectToUserDefaults:situationIds withKey:kVisitedSituationIdsKey];
}

#pragma mark - Regions

- (OBARegionV2*)readOBARegion {
    return [self.class loadAndDecodeObjectFromDataForKey:kOBARegionKey];
}

- (void)writeOBARegion:(OBARegionV2 *)region {
    [self.class writeObjectToUserDefaults:region withKey:kOBARegionKey];
}

- (NSSet<OBARegionV2*>*)customRegions {
    @synchronized (self) {
        return [self.class loadAndDecodeObjectFromDataForKey:kCustomRegionsKey] ?: [NSSet set];
    }
}

- (void)addCustomRegion:(OBARegionV2*)region {
    [self addObject:region toSetWithKey:kCustomRegionsKey];
}

- (void)removeCustomRegion:(OBARegionV2*)region {
    [self removeObject:region fromSetWithKey:kCustomRegionsKey];
}

- (BOOL)readSetRegionAutomatically {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSetRegionAutomaticallyKey];
}

- (void)writeSetRegionAutomatically:(BOOL)setRegionAutomatically {
    [[NSUserDefaults standardUserDefaults] setBool:setRegionAutomatically forKey:kSetRegionAutomaticallyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Privacy/PII

- (BOOL)shareRegionPII {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OBAShareRegionPIIUserDefaultsKey];
}

- (void)setShareRegionPII:(BOOL)shareRegionPII {
    [[NSUserDefaults standardUserDefaults] setBool:shareRegionPII forKey:OBAShareRegionPIIUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shareLocationPII {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OBAShareLocationPIIUserDefaultsKey];
}

- (void)setShareLocationPII:(BOOL)shareLocationPII {
    [[NSUserDefaults standardUserDefaults] setBool:shareLocationPII forKey:OBAShareLocationPIIUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shareLogsPII {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OBAShareLogsPIIUserDefaultsKey];
}

- (void)setShareLogsPII:(BOOL)shareLogsPII {
    [[NSUserDefaults standardUserDefaults] setBool:shareLogsPII forKey:OBAShareLogsPIIUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Shared Trips

- (NSSet<OBATripDeepLink*>*)sharedTrips {
    @synchronized (self) {
        return [self.class loadAndDecodeObjectFromDataForKey:kSharedTripsKey] ?: [NSSet set];
    }
}

- (void)addSharedTrip:(OBATripDeepLink*)sharedTrip {
    [self addObject:sharedTrip toSetWithKey:kSharedTripsKey];
}

- (void)removeSharedTrip:(OBATripDeepLink*)sharedTrip {
    [self removeObject:sharedTrip fromSetWithKey:kSharedTripsKey];
}

#pragma mark - Generic Set Management Methods

- (void)addObject:(id)object toSetWithKey:(NSString*)key {
    OBAGuard(object && key.length > 0) else {
        return;
    }

    @synchronized (self) {
        NSSet *set = [self.class loadAndDecodeObjectFromDataForKey:key] ?: [NSSet set];
        NSMutableSet *mutableSet = [NSMutableSet setWithSet:set];
        [mutableSet addObject:object];
        [self.class writeObjectToUserDefaults:mutableSet withKey:key];
    }
}

- (void)removeObject:(id)object fromSetWithKey:(NSString*)key {
    OBAGuard(object && key.length > 0) else {
        return;
    }

    @synchronized (self) {
        NSSet *set = [self.class loadAndDecodeObjectFromDataForKey:key] ?: [NSSet set];
        NSMutableSet *mutableSet = [NSMutableSet setWithSet:set];
        [mutableSet removeObject:object];
        [self.class writeObjectToUserDefaults:mutableSet withKey:key];
    }
}

#pragma mark - (De-)Serialization

+ (id)loadAndDecodeObjectFromDataForKey:(NSString*)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:key];

    if (!data) {
        return nil;
    }

    id object = nil;

    @try {
        NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        object = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
    }
    @catch (NSException *exception) {
        DDLogError(@"Unable to decode object for key %@ - %@", key, exception);
    }

    return object;
}

+ (void)writeObjectToUserDefaults:(id<NSCoding>)object withKey:(NSString*)key {
    NSMutableData * data = [NSMutableData data];

    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
