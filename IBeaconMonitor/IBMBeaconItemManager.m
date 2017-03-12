//
//  IbeaconItemManager.m
//  IBeaconMonitor
//
//  Created by Leon on 17/3/9.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "IBMBeaconItemManager.h"


// 本地存储Key值
static NSString *const beaconItemsStoreKey = @"beaconItemsStoreKey";

@implementation IBMBeaconItemManager
@synthesize storeItemsData = _storeItemsData;
@synthesize storeItems = _storeItems;

+ (instancetype)sharedInstanced {
    static IBMBeaconItemManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (void)TraverseStoreItemsHandle:(TraverseBeaconItemHandle)itemHandle {
    if (self.storeItemsData) {
        for (NSData *itemData in _storeItemsData) {
            IBMBeaconItem *ibeaconItem = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            itemHandle(ibeaconItem);
        }
    }
}

- (void)syncStoreItemsWithLatestItems:(NSArray<IBMBeaconItem *> *)latestItems {
    NSMutableArray *cacheItemsData = [NSMutableArray array];
    for (IBMBeaconItem *item in latestItems) {
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [cacheItemsData addObject:itemData];
    }
    _storeItemsData = [cacheItemsData copy];
    _storeItems     = [latestItems copy];
    [[NSUserDefaults standardUserDefaults] setObject:_storeItemsData forKey:beaconItemsStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSArray<NSData *> *)storeItemsData {
    
    if (!_storeItemsData) {
        
        _storeItemsData = [[NSUserDefaults standardUserDefaults] objectForKey:beaconItemsStoreKey];
        
    }
    return _storeItemsData;
}

- (NSArray<IBMBeaconItem *> *)storeItems {
    
    if (!_storeItems) {
        NSMutableArray *mutableStoreItems = [NSMutableArray array];
        if (self.storeItemsData) {
            for (NSData *itemData in _storeItemsData) {
                IBMBeaconItem *ibeaconItem = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
                [mutableStoreItems addObject:ibeaconItem];
            }
        }
        _storeItems = [mutableStoreItems copy];
    }
    return _storeItems;
}

@end
