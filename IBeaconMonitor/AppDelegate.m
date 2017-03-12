//
//  AppDelegate.m
//  IBeaconMonitor
//
//  Created by Leon on 17/2/10.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "IBMBeaconItemManager.h"

@interface AppDelegate ()<CLLocationManagerDelegate, UIApplicationDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.locationManager.delegate = self;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 本地通知接收
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [self alertMessage:notification.alertBody];
}

#pragma mark - CLLocationManagerDelegate
// 进入到iBeacon区域(会有延迟,大概30s)
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self matchIbeaconRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    NSLog(@"离开iBeacon区域");
}

// requestStateForRegion:方法调用就会触发该代理方法,另外从黑屏到亮屏过程也会触发
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    
    switch (state) {
        case CLRegionStateUnknown:
        {
            NSLog(@"未知");
        }
            break;
        case CLRegionStateInside:
        {
            NSLog(@"在iBeacon区域里面");
            if ([region isKindOfClass:[CLBeaconRegion class]]) {
                CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
                [self matchIbeaconRegion:beaconRegion];
            }
        }
            break;
        case CLRegionStateOutside:
        {
            NSLog(@"在iBeacon区域外面");
        }
            break;
    }
}

// CLBeaconRegion 来匹配与之对应的 IBMBeaconItem
- (void)matchIbeaconRegion:(CLBeaconRegion *)ibeaconRegion {
    
    NSArray<IBMBeaconItem *> * beaconItems = [IBMBeaconItemManager sharedInstanced].storeItems;
    for (IBMBeaconItem *item in beaconItems) {
        if ([item isEqualToCLBeaconRegion:ibeaconRegion]) {
            [self sendLocalNotificationWithIbeaconItem:item];
        }
    }
}

// 弹出提示框
- (void)alertMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

// 发送本地通知(弹出框)
- (void)sendLocalNotificationWithIbeaconItem:(IBMBeaconItem *)ibeaconItem {
    
    if ([ibeaconItem shouldSendNotificaiton]) {
        
        NSString *notifyString = [NSString stringWithFormat:@"进入%@的iBeacon区域",ibeaconItem.name];
        UIApplicationState appState = [UIApplication sharedApplication].applicationState;
        switch (appState) {
            case UIApplicationStateActive: // 在前台
            {
                [self alertMessage:notifyString];
                
                break;
            }
            case UIApplicationStateBackground: // 在后台
            {
                // 通知的代码
                UILocalNotification *notice = [[UILocalNotification alloc] init];
                notice.alertBody = notifyString;
                //        notice.alertAction = @"iBeacon区域提醒";
                [[UIApplication sharedApplication] scheduleLocalNotification:notice];
                
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                break;
                
            }
             default:
                break;
        }
    }
    
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}


@end
