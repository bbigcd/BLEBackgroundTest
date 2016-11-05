//
//  ViewController.m
//  BLEBackgroundTest
//
//  Created by bbigcd on 16/11/5.
//  Copyright © 2016年 chendi. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *manger;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manger = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"restoreIdentifier"}];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBPeripheralManagerStatePoweredOn) {
        [_manger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEE7"], [CBUUID UUIDWithString:@"FFFF"], [CBUUID UUIDWithString:@"FFC0"]] options:nil];
        NSLog(@"open bluetooth");
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%@", advertisementData);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}


@end
