//
//  CBCentralManager+Addition.m
//  Thermometer
//
//  Created by Tonny on 8/13/13.
//  Copyright (c) 2013 Doouya. All rights reserved.
//

#import "CBCentralManager+Addition.h"

@implementation CBCentralManager (Addition)

- (void)cleanupConnectedPeripheral:(CBPeripheral *)peripheral withCharacteristicUUID:(CBUUID *)CUUID{
    peripheral.delegate = nil;
    
    if (peripheral.state == CBPeripheralStateDisconnected) {
        return;
    }
    
    if (peripheral.services != nil) {
        [peripheral.services enumerateObjectsUsingBlock:^(CBService *service, NSUInteger idx, BOOL *stop) {
            [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic *characteristic, NSUInteger idx, BOOL *stop) {
                if ([characteristic.UUID isEqual:CUUID]) {
                    if (characteristic.isNotifying) {
                        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
                    }
                }
            }];
        }];
    }
    
    [self cancelPeripheralConnection:peripheral];
}


- (void)cleanupConnectedPeripheral:(CBPeripheral *)peripheral{

    peripheral.delegate = nil;
    
    if (peripheral.state == CBPeripheralStateDisconnected) {
        return;
    }
    
    if (peripheral.services != nil) {
        [peripheral.services enumerateObjectsUsingBlock:^(CBService *service, NSUInteger idx, BOOL *stop) {
            [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic *characteristic, NSUInteger idx, BOOL *stop) {
                if (characteristic.isNotifying) {
                    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }];
        }];
    }
    
    [self cancelPeripheralConnection:peripheral];

}
@end
