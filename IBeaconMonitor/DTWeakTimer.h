//
//  DTWeakTimer.h
//  IBeaconMonitor
//
//  Created by Leon on 17/2/24.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTWeakTimer : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

@end
