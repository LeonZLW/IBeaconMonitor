//
//  ViewController.m
//  IBeaconMonitor
//
//  Created by Leon on 17/2/10.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "IBMBeaconViewController.h"
#import "IBMAddItemViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "IBMBeaconInfoCell.h"
#import "IBMBeaconItemManager.h"

@interface IBMBeaconViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

// 定位管理
@property (nonatomic, strong) CLLocationManager *locationManager;
// 存放IBMBeaconItem的数组
@property (nonatomic, strong) NSMutableArray *beaconItems;
// tableView视图
@property (weak, nonatomic) IBOutlet UITableView *beaconTableView;

@end

@implementation IBMBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beaconTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.beaconTableView.estimatedRowHeight = 140;
    self.beaconTableView.rowHeight = UITableViewAutomaticDimension;
    [self rightNavigationConfig];
    [self loadIbeaconItem];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.beaconItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IBMBeaconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IBMBeaconInfoCell class]) forIndexPath:indexPath];
    IBMBeaconItem *ibeaconItem = self.beaconItems[indexPath.row];
    cell.currentBeaconItem = ibeaconItem;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IBMBeaconItem *ibeaconItem = self.beaconItems[indexPath.row];
    [self jumpToAddItemViewControllerWithItem:ibeaconItem];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self stopMonitoringWithItem:self.beaconItems[indexPath.row]];
        [tableView beginUpdates];
        [self.beaconItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        [self syncStoreItems];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    if (region) {
        // 调用requestStateForRegion:方法会触发locationManager:didDetermineState:forRegion:代理方法,你可以在代理方法中判断你是否在iBeacon区域。如果你刚开始就在iBeacon的区域,不是从边界的地方进来的,就不会触发locationManager:didEnterRegion:代理方法
        [manager requestStateForRegion:region];
    }
}

// 这个代理方法中的beacons参数存放的是附近相同标识iBeacon的数组,比如:我们配置了5个iBeacon的UUID,Major,Minor的值是一样的,那么iBeacon数组中就是5个,它们由近到远排列的
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    for (CLBeacon *beacon in beacons) {
        for (IBMBeaconItem *beaconItem in self.beaconItems) {
            if ([beaconItem isEqualToCLBeacon:beacon]) {
                beaconItem.beaconMatching = beacon;
            }
        }
    }
}

#pragma mark - 步骤1
- (void)loadIbeaconItem {
    // 读取本地数据
    [[IBMBeaconItemManager sharedInstanced] TraverseStoreItemsHandle:^(IBMBeaconItem *item) {
        // 每取到一个IBMBeaconItem 开始对它进行监听
        [self startMonitoringWithItem:item];
        // 添加到tableView的资源数组
        [self.beaconItems addObject:item];
    }];
}

- (void)rightNavigationConfig {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickedRightBarbuttonItemAction:)];
}

- (void)syncStoreItems {
    [[IBMBeaconItemManager sharedInstanced] syncStoreItemsWithLatestItems:[self.beaconItems copy]];
}

- (void)clickedRightBarbuttonItemAction:(UIBarButtonItem *)barButtonItem {
    [self jumpToAddItemViewControllerWithItem:nil];
}

- (void)jumpToAddItemViewControllerWithItem:(IBMBeaconItem *)ibeaconItem {
    
    IBMAddItemViewController *addItemVC = [[IBMAddItemViewController alloc]init];
    addItemVC.ibeaconName = ibeaconItem.name;
    addItemVC.ibeaconUUID = ibeaconItem.uuid;
    
    if (ibeaconItem.majorValue) {
        addItemVC.ibeaconMarjorValue = [NSString stringWithFormat:@"%d", ibeaconItem.majorValue];
    }
    
    if (ibeaconItem.minorValue) {
        addItemVC.ibeaconMinorValue = [NSString stringWithFormat:@"%d", ibeaconItem.minorValue];
    }
    
    if (ibeaconItem == nil) {
        
        [addItemVC setConfigItemCompletion:^(IBMBeaconItem *addBeaconItem) {
            
            [self.beaconItems addObject:addBeaconItem];
            [self.beaconTableView beginUpdates];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.beaconItems.count - 1 inSection:0];
            [self.beaconTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.beaconTableView endUpdates];
            
            [self startMonitoringWithItem:addBeaconItem];
            [self syncStoreItems];
        }];
        
    }else {
        
        [addItemVC setConfigItemCompletion:^(IBMBeaconItem *modifiedBeaconItem) {
            
            [self stopMonitoringWithItem:ibeaconItem];
            
            NSUInteger iBeaconItemsIndex = [self.beaconItems indexOfObject:ibeaconItem];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:iBeaconItemsIndex inSection:0];
            
            [self.beaconItems removeObject:ibeaconItem];
            [self.beaconItems insertObject:modifiedBeaconItem atIndex:iBeaconItemsIndex];
            [self.beaconTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self startMonitoringWithItem:modifiedBeaconItem];
            [self syncStoreItems];
        }];
    }
    
    UINavigationController *addNV = [[UINavigationController alloc]initWithRootViewController:addItemVC];
    [self presentViewController:addNV
                       animated:YES
                     completion:nil];
    
}

#pragma mark - 步骤3
- (CLBeaconRegion *)generateBeaconRegionWithItem:(IBMBeaconItem *)ibeaconItem {
    // 生成iBeacon区域实例,表示我们要监视的区域
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:ibeaconItem.uuid
                                                         major:ibeaconItem.majorValue
                                                         minor:ibeaconItem.minorValue
                                                    identifier:ibeaconItem.name];
    // 从黑屏->亮屏 通知- (void)locationManager:didDetermineState:forRegion:代理方法
    beaconRegion.notifyEntryStateOnDisplay = YES;
    return beaconRegion;
}

#pragma mark - 步骤2
- (void)startMonitoringWithItem:(IBMBeaconItem *)ibeaconItem {
    
    CLBeaconRegion *beaconRegion = [self generateBeaconRegionWithItem:ibeaconItem];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringWithItem:(IBMBeaconItem *)ibeaconItem {
    CLBeaconRegion *beaconRegion = [self generateBeaconRegionWithItem:ibeaconItem];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        // iOS8后要手动授权
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

- (NSMutableArray *)beaconItems {
    if (!_beaconItems) {
        _beaconItems = [NSMutableArray array];
    }
    return _beaconItems;
}

@end
