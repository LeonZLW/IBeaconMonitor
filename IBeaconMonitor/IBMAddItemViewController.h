//
//  IBMAddItemViewController.h
//  IBeaconMonitor
//
//  Created by Leon on 17/2/17.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBMBeaconItem;


typedef void(^ConfigItemCompletion)(IBMBeaconItem *ibeaconItem);
@interface IBMAddItemViewController : UIViewController
@property (nonatomic, copy) ConfigItemCompletion configItemCompletion;

@property (nonatomic, copy) NSString *ibeaconName;
@property (nonatomic, copy) NSUUID *ibeaconUUID;
@property (nonatomic, copy) NSString *ibeaconMarjorValue;
@property (nonatomic, copy) NSString *ibeaconMinorValue;


@end
