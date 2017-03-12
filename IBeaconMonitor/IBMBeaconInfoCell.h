//
//  IbeaconInfoCell.h
//  IBeaconMonitor
//
//  Created by Leon on 17/3/7.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import <UIKit/UIKit.h>
@class IBMBeaconItem;

@interface IBMBeaconInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rrsiLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

@property (strong, nonatomic) IBMBeaconItem *currentBeaconItem;



@end
