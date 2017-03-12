//
//  DTWeakTimer.m
//  IBeaconMonitor
//
//  Created by Leon on 17/2/24.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "DTWeakTimer.h"

@implementation DTWeakTimer

- (void)fire:(NSTimer *)timer {
    if(self.target) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    } else {
        [self.timer invalidate];
    }
}

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats {
    
    DTWeakTimer* timerTarget = [[DTWeakTimer alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(fire:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    return timerTarget.timer;
}

@end
