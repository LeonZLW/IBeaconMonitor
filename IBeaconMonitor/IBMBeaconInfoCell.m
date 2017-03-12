//
//  IbeaconInfoCell.m
//  IBeaconMonitor
//
//  Created by Leon on 17/3/7.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "IBMBeaconInfoCell.h"
#import "IBMBeaconItem.h"

@implementation IBMBeaconInfoCell

- (void)dealloc {
    [_currentBeaconItem removeObserver:self forKeyPath:@"beaconMatching"];
}

- (void)setCurrentBeaconItem:(IBMBeaconItem *)currentBeaconItem {
    
    if (_currentBeaconItem) {
        [_currentBeaconItem removeObserver:self forKeyPath:@"beaconMatching"];
    }
    
    if (currentBeaconItem) {
        
        _currentBeaconItem = currentBeaconItem;
        
        [_currentBeaconItem addObserver:self
                             forKeyPath:@"beaconMatching"
                                options:NSKeyValueObservingOptionNew
                                context:nil];
        self.nameLabel.text = _currentBeaconItem.name;
        self.uuidLabel.text = _currentBeaconItem.uuid.UUIDString;
        self.majorLabel.text = [NSString stringWithFormat:@"%d", _currentBeaconItem.majorValue];
        self.minorLabel.text = [NSString stringWithFormat:@"%d", _currentBeaconItem.minorValue];
    }
    
}

- (NSString *)nameForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            return @"Unknown";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityFar:
            return @"Far";
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([object isEqual:self.currentBeaconItem] && [keyPath isEqualToString:@"beaconMatching"]) {
        
        self.rrsiLabel.text = [NSString stringWithFormat:@"%ld", self.currentBeaconItem.beaconMatching.rssi];
        self.proximityLabel.text = [self nameForProximity:self.currentBeaconItem.beaconMatching.proximity];
        self.accuracyLabel.text = [NSString stringWithFormat:@"%f 米", self.currentBeaconItem.beaconMatching.accuracy];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
