//
//  IbeaconItem.h
//  IBeaconMonitor
//
//  Created by Leon on 17/2/16.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface IBMBeaconItem : NSObject<NSCoding>

// 设备的名字(identifier)
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
// 记录每次通知的时间
@property (nonatomic, strong) NSDate *lastNotifyDate;
// 匹配Beacon设备信息
@property (nonatomic, strong) CLBeacon *beaconMatching;


- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;


/**
 判断IBMBeaconItem实例的信息是否与检测到的区域相同

 @param beaconRegion CLBeaconRegion区域实例
 @return 判断结果
 */
- (BOOL)isEqualToCLBeaconRegion:(CLBeaconRegion *)beaconRegion;


/**
 判断是否需要发送通知(当前时间 - 上次通知记录的时间(lastNotifyDate) > 规定的时间  就返回YES发送通知 否则NO)

 @return 判断结果
 */
- (BOOL)shouldSendNotificaiton;


/**
 判断IBMBeaconItem实例的信息是否与检测到的设备信息相同

 @param beacon 设备实例
 @return 判断结果
 */
- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
