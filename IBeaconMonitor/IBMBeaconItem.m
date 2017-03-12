//
//  IbeaconItem.m
//  IBeaconMonitor
//
//  Created by Leon on 17/2/16.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "IBMBeaconItem.h"

static NSString *const ibeaconName = @"ibeaconName";
static NSString *const iBeaconUUID = @"iBeaconUUID";
static NSString *const iBeaconMajor = @"iBeaconMajor";
static NSString *const iBeaconMinor = @"iBeaconMinor";
static NSString *const iBeaconLastNotifyDate = @"iBeaconLastNotifyDate";

// 过期时间间隔,默认是10.0s (当前时间 - 上次发送通知时间 > expiredTime 就发送通知)
static const NSTimeInterval expiredTime = 1.0;

@implementation IBMBeaconItem

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
{
    self = [super init];
    
    if (self) {
        _name = name;
        _uuid = uuid;
        _majorValue = major;
        _minorValue = minor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        _name = [aDecoder decodeObjectForKey:ibeaconName];
        _uuid = [aDecoder decodeObjectForKey:iBeaconUUID];
        _majorValue = [[aDecoder decodeObjectForKey:iBeaconMajor] unsignedIntegerValue];
        _minorValue = [[aDecoder decodeObjectForKey:iBeaconMinor] unsignedIntegerValue];
        _lastNotifyDate = [aDecoder decodeObjectForKey:iBeaconLastNotifyDate];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:ibeaconName];
    [aCoder encodeObject:self.uuid forKey:iBeaconUUID];
    [aCoder encodeObject:@(self.majorValue) forKey:iBeaconMajor];
    [aCoder encodeObject:@(self.minorValue) forKey:iBeaconMinor];
    [aCoder encodeObject:self.lastNotifyDate forKey:iBeaconLastNotifyDate];
}

- (BOOL)isEqualToCLBeaconRegion:(CLBeaconRegion *)beaconRegion {
    
    return [self isEqualToBeaconInfo:beaconRegion];
}

- (BOOL)isEqualToBeaconInfo:(id)beaconInfo {
    if ([[[beaconInfo valueForKey:@"proximityUUID"] UUIDString] isEqualToString:[self.uuid UUIDString]] &&
        [[beaconInfo valueForKey:@"major"] isEqual: @(self.majorValue)] &&
        [[beaconInfo valueForKey:@"minor"] isEqual: @(self.minorValue)])
    {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon {
    
    return [self isEqualToBeaconInfo:beacon];
}

- (BOOL)shouldSendNotificaiton {
    
    if (self.lastNotifyDate == nil) {
        
        [self updateLastNotifyDate];
        return YES;
    }else {
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastNotifyDate];
        BOOL isNeedUpdate = timeInterval > expiredTime ? YES : NO;
        
        if (isNeedUpdate) {
            
            [self updateLastNotifyDate];
            return YES;
        }else {
            
            return NO;
        }
    }
}

- (void)setLastNotifyDate:(NSDate *)lastNotifyDate {
    if (lastNotifyDate) {
        _lastNotifyDate = lastNotifyDate;
    }
}

- (void)updateLastNotifyDate {
    self.lastNotifyDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
}

- (NSString *)description {
    NSString *descriptionStr = [NSString stringWithFormat:@"name=%@\n uuid=%@ \n majorValue=%d minorValue=%d \n lastNotifyDate=%@", _name,_uuid,_majorValue,_minorValue, _lastNotifyDate];
    return descriptionStr;
}

@end
