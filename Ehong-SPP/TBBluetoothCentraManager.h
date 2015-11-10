//
//  TBBluetoothCentraManager.h
//  Thermometer
//
//  Created by Tonny on 8/13/13.
//  Copyright (c) 2013 Doouya. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;
#import "blocktypedef.h"

/* time bit field */



@interface TBBluetoothCentraManager : NSObject

@property (nonatomic, assign) CBPeripheralState peripheralState;
@property (nonatomic, assign) CBCentralManagerState centralState;
@property(strong,nonatomic) CBPeripheral *peripheral;       //不保存此索引的话,Discover service时会被alloc掉出错

+ (instancetype)sharedInstance;
- (void)startScan;

- (BOOL)isBluetoothCommandSendable;

- (void)writeToPeripheralWithData:(NSData *)data;
- (void)sendTestBytes;
@end
