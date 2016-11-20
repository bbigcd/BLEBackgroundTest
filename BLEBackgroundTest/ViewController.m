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
@property (nonatomic, strong) CBPeripheral *myPeripheral;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isConnecting;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.manger = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"restoreIdentifier"}];
}

- (void)reConnectPeripheral{
    if (!_isConnecting) {
        [_manger connectPeripheral:_myPeripheral options:nil];
    }
}

#pragma mark -- CBCentralManagerDelegate --

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBPeripheralManagerStatePoweredOn) {
        // 实现后台链接必须指定Services，否则不会触发下面的代理方法
        // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
        [_manger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEE7"]] options:nil];
        NSLog(@"open bluetooth");
    }
}

// 勾选了后台模式，willRestoreState方法必须使用
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%@", peripheral);
    self.myPeripheral = peripheral;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reConnectPeripheral) userInfo:nil repeats:YES];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"链接失败 : %@", [error localizedDescription]);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"失去链接 : %@", [error localizedDescription]);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"didConnectPeripheral");
    self.isConnecting = YES;
}


- (void)dealloc{
    [self.timer invalidate];
}
@end
