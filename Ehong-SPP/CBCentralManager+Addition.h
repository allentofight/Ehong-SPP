//
//  CBCentralManager+Addition.h
//  Thermometer
//
//  Created by Tonny on 8/13/13.
//  Copyright (c) 2013 Doouya. All rights reserved.
//

@import CoreBluetooth;

@interface CBCentralManager (Addition)

- (void)cleanupConnectedPeripheral:(CBPeripheral *)peripheral withCharacteristicUUID:(CBUUID *)CUUID;
- (void)cleanupConnectedPeripheral:(CBPeripheral *)peripheral;
@end
