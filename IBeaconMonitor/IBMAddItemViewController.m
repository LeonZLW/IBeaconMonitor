//
//  IBMAddItemViewController.m
//  IBeaconMonitor
//
//  Created by Leon on 17/2/17.
//  Copyright © 2017年 Datuhongan All rights reserved.
//

#import "IBMAddItemViewController.h"
#import "IBMBeaconItem.h"
#import "DTWeakTimer.h"


@interface IBMAddItemViewController ()
{
    BOOL identiferValid; // 设备名称是否有效
    BOOL uuidValid; // uuid是否有效
    BOOL isModify; //  是否是修改操作
}
@property (weak, nonatomic) IBOutlet UITextField *identifierTextfield;
@property (weak, nonatomic) IBOutlet UITextField *uuidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *majorTextfield;
@property (weak, nonatomic) IBOutlet UITextField *minorTextfield;

@property (strong, nonatomic) NSRegularExpression *uuidRegex;

@end

@implementation IBMAddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.ibeaconName == nil && self.ibeaconUUID == nil && self.ibeaconMarjorValue == nil && self.ibeaconMinorValue == nil) {
        
        self.title = @"配置iBeacon参数";
        isModify = NO;
        identiferValid = NO;
        uuidValid = NO;
        
    }else {
        
        self.title = @"修改iBeacon参数";
        _identifierTextfield.text = self.ibeaconName;
        _uuidTextfield.text = self.ibeaconUUID.UUIDString;
        _majorTextfield.text = self.ibeaconMarjorValue;
        _minorTextfield.text = self.ibeaconMinorValue;
        isModify = YES;
        identiferValid = YES;
        uuidValid = YES;
    }
    
    [self navigationBarButtonItemConfig];
    [self textfieldsConfig];
}

- (void)navigationBarButtonItemConfig {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackBarButtonItemConfig)];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickedRightBarbuttonItemAction:)];
    
    self.navigationItem.rightBarButtonItem.enabled = isModify;
}

- (void)clickedBackBarButtonItemConfig {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clickedRightBarbuttonItemAction:(UIBarButtonItem *)barButtonItem {
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:self.uuidTextfield.text];
    
    IBMBeaconItem *ibeaconItem = [[IBMBeaconItem alloc]initWithName:self.identifierTextfield.text
                                                           uuid:uuid
                                                          major:[self.majorTextfield.text intValue]
                                                          minor:[self.minorTextfield.text intValue]];
    self.configItemCompletion(ibeaconItem);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textfieldsConfig {
    
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    self.uuidRegex = [[NSRegularExpression alloc]initWithPattern:uuidPatternString
                                                         options:NSRegularExpressionCaseInsensitive
                                                           error:nil];
    
    [self.identifierTextfield addTarget:self
                                action:@selector(identiferTextfieldChanged:)
                      forControlEvents:UIControlEventEditingChanged];
    
    [self.uuidTextfield addTarget:self
                           action:@selector(uuidTextfieldChanged:)
                 forControlEvents:UIControlEventEditingChanged];
}

- (void)identiferTextfieldChanged:(UITextField *)textfield {
    if (textfield.text.length > 0) {
        identiferValid = YES;
    }else {
        identiferValid = NO;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = identiferValid && uuidValid;
}

- (void)uuidTextfieldChanged:(UITextField *)textfield {
    NSInteger numberOfMachs = [self.uuidRegex numberOfMatchesInString:textfield.text
                                                              options:kNilOptions
                                                                range:NSMakeRange(0, textfield.text.length)];
    if (numberOfMachs > 0) {
        uuidValid = YES;
    }else {
        uuidValid = NO;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = identiferValid && uuidValid;
}



@end
