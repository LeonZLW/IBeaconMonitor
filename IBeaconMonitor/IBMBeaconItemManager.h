//
//  IbeaconItemManager.h
//  IBeaconMonitor
//
//  Created by Leon on 17/3/9.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMBeaconItem.h"


typedef void(^TraverseBeaconItemHandle)(IBMBeaconItem *item);

@interface IBMBeaconItemManager : NSObject

// 存放IBMBeaconItem对象转化成Data类型后的数组
@property (nonatomic, copy, readonly) NSArray<NSData *> *storeItemsData;
// 存放IBMBeaconItem对象的数组
@property (nonatomic, copy, readonly) NSArray<IBMBeaconItem *> *storeItems;

+ (instancetype)sharedInstanced;


/**
 同步本地数据,比如在客户端我们在做添加/删除/修改 操作的时候,要与本地的数据同步一下

 @param latestItems 要同步的数组<IBMBeaconItem *>
 */
- (void)syncStoreItemsWithLatestItems:(NSArray<IBMBeaconItem *> *)latestItems;


/**
 遍历本地存放的ItemData,把Data转化成IBMBeaconItem并每一次遍历都会把IBMBeaconItem通过TraverseBeaconItemHandle传到调用的地方,详情请看实现代码

 @param itemHandle Block
 */
- (void)TraverseStoreItemsHandle:(TraverseBeaconItemHandle)itemHandle;

@end
