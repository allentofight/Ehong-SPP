 //
//  TBBluetoothCentraManager.m
//  Thermometer
//
//  Created by Tonny on 8/13/13.
//  Copyright (c) 2013 Doouya. All rights reserved.
//

@import CoreBluetooth;
@import AudioToolbox;

#import "TBBluetoothCentraManager.h"
#import "CBCentralManager+Addition.h"
#import "CONSTANTS.h"
#import "DataEnv.h"

//////////Doouya体温 Service

//////////电量 Service

#define Service_BROADCAST_UUID              [CBUUID UUIDWithString:@"11223344-5566-7788-99AA-BBCCDDEEFF00"]

#define CHARACT_WERITE_UUID                 [CBUUID UUIDWithString:@"F0121122-3344-5566-7788-99AABBCCDDEE"]

#define CHARACT_NOTIFY_UUID                 [CBUUID UUIDWithString:@"F0131122-3344-5566-7788-99AABBCCDDEE"]

#define NOTIFY_ON 1

#define DEVICE_NAME @"babyhero"


#define IS_SELECT_DEVICE_ON                 0

@interface TBBluetoothCentraManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
@end

typedef struct {
    NSUInteger receivedLength;
    NSUInteger receivedType;
    NSUInteger receivedSequenceId;
    NSInteger receivedCRS16;
}ReceivedData;

@implementation TBBluetoothCentraManager{
    CBCentralManager      *_centralManager;
    
    BOOL                _isScaning;
    CBCharacteristic   *_notifyCharacteristic;
    CBCharacteristic   *_writeCharacteristic;

    NSInteger _sendedSequenceId;            //开始发送的SequenceId
    
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

static dispatch_queue_t bluetooth_queue() {
    static dispatch_queue_t _queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_queue_create("com.doouya.thermometor.bluetooth.central", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return _queue;
}


- (id)init{
    self = [super init];
    
    if (self) {
        if (_centralManager) {
            if (!_peripheral) {
                [self startScan];
            }
        }else{
            _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                   queue:bluetooth_queue()
                                                                 options:@{CBCentralManagerOptionShowPowerAlertKey:@YES,
                                                                           CBCentralManagerOptionRestoreIdentifierKey:@"myCentralManagerIdentifier"}];
        }

    }
    return self;
}


- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)state {
    SLLog();
    NSArray *peripherals =
    state[CBCentralManagerRestoredStatePeripheralsKey];
    if ([peripherals count] > 0) {
        CBPeripheral *peripheral = [peripherals lastObject];
        [central connectPeripheral:peripheral options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
    }
    
}

- (void)setPeripheralState:(CBPeripheralState)peripheralState{
    _peripheralState = peripheralState;
}



#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    SLLog(@"Central manager state: %ld", (long)[central state]);
    SLLog(@"Thread: %d", [NSThread isMainThread]);
    self.centralState = central.state;
    if (central.state == CBCentralManagerStatePoweredOff){
        //蓝牙未打开,弹出提示框
        self.peripheralState = CBPeripheralStateDisconnected;
        [self stopScan];
        
    }else if (central.state == CBCentralManagerStatePoweredOn){
#if !IS_SELECT_DEVICE_ON
        [self startScan];
#endif
    }
}


#pragma mark - Scane Peripheral

/*q
 需要用到重新自动连接的话需要指定Services,否则不会自动重连接.
 
 如果已经连接的话,notify永远正常
 background状态(10秒)  断连接后可以自动连接
 suspend状态(10秒后)
 
 CBCentralManagerScanOptionAllowDuplicatesKey 默认为NO, 同一设备的重复信号过滤掉
 */

- (void)startScan{
    //    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //CBCentralManagerScanOptionSolicitedServiceUUIDsKey,
    
    if (self.peripheralState == CBPeripheralStateDisconnected) {
        return;
    }
    
    if (_centralManager.state != CBCentralManagerStatePoweredOn) return;
    
    [_centralManager scanForPeripheralsWithServices:@[Service_BROADCAST_UUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}]; //C

}

-(void) writeValue:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data{
    if ([peripheral state] == CBPeripheralStateConnected)
    {
        if (characteristic != nil) {
            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

- (void)discoverService:(CBUUID *)serviceUUID discoverCharacteristic:(CBUUID *)chaUUID peripheral:(CBPeripheral *)peripheral{
    NSUInteger index = [peripheral.services indexOfObjectPassingTest:^BOOL(CBService *obj, NSUInteger idx, BOOL *stop) {
        return ([obj.UUID isEqual:serviceUUID]);
    }];
    
    if (index == NSNotFound){ //检查缓存设备 是否有Service
        [peripheral discoverServices:@[serviceUUID]];
        return ;
    }
    
    CBService *service = peripheral.services[index];
    index = [service.characteristics indexOfObjectPassingTest:^BOOL(CBCharacteristic *cha, NSUInteger idx, BOOL *stop) {
        return ([cha.UUID isEqual:cha]);
    }];
    
    if (index == NSNotFound){ //检查缓存设备的Service 是否有Characteristic
        [peripheral discoverCharacteristics:@[chaUUID] forService:service];
        return ;
    }
}

- (void)stopScan{
    if (_peripheral) {
        [_centralManager cleanupConnectedPeripheral:_peripheral];
        _peripheral = nil;
    }
}

- (void)disconnect{
    if (!_peripheral) {
        [_centralManager stopScan];
        return;
    }
    
    if (_peripheral) {
        [_centralManager cleanupConnectedPeripheral:_peripheral];
        _peripheral = nil;
    }
    [_centralManager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
//找到一个设备后就不再继续找其他设备
    [_centralManager stopScan];
    
    SLLog(@"开始连接 %@", peripheral.name);
    if (_peripheral != peripheral) {
        _peripheral = peripheral;
        self.peripheralState = CBPeripheralStateConnecting;
        [_centralManager connectPeripheral:peripheral
                                   options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                             CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                             CBConnectPeripheralOptionNotifyOnNotificationKey:@YES}];
    }
    
}

#pragma mark - Connect Peripheral

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    //cancel reconnect function
    SLLog(@"连上设备....%@", peripheral.name);
    SLLog(@"Peripheral Connected %@\n", peripheral);
    peripheral.delegate = self;
    self.peripheralState = peripheral.state;
    [peripheral discoverServices:@[Service_BROADCAST_UUID]];
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    static int count = 0;
    if (count < 5) {
        count++;
        //尝试再次连接
        [_centralManager connectPeripheral:peripheral
                                   options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                             CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                             CBConnectPeripheralOptionNotifyOnNotificationKey:@YES}];
    }
    
    SLLog(@"Failed to connect to %@. (%@)\n", peripheral, [error localizedDescription]);
}

#pragma mark - Discover Services

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        SLLog(@"Error discovering services: %@\n", [error localizedDescription]);
        //        [_centralManager cleanupConnectedPeripheral:peripheral withCharacteristicUUID:CHARACT_Height_UUID];
        return;
    }
    
    [peripheral.services enumerateObjectsUsingBlock:^(CBService *service, NSUInteger idx, BOOL *stop) {
        if ([service.UUID isEqual:Service_BROADCAST_UUID]){
            [peripheral discoverCharacteristics:@[CHARACT_NOTIFY_UUID, CHARACT_WERITE_UUID] forService:service];
        }
    }];
}

#pragma mark - Discover Characteristics

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        SLLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [_centralManager cleanupConnectedPeripheral:peripheral withCharacteristicUUID:service.UUID];
        return;
    }
    
    if ([service.UUID isEqual:Service_BROADCAST_UUID]){
        [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic *characteristic, NSUInteger idx, BOOL *stop) {
            
            if ([characteristic.UUID isEqual:CHARACT_NOTIFY_UUID]) {
                _notifyCharacteristic = characteristic;
                    SLLog(@"打开notify...");
                [peripheral setNotifyValue:NOTIFY_ON forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:CHARACT_WERITE_UUID]){
                _writeCharacteristic = characteristic;
            }
        }];
    }
}

- (void)sendTestBytes{
    Byte bytes[] = {0x01,0xF1,0xF2,0,0x01,0x02,0,0,0,0};
    NSData *L2Header = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    [self writeToPeripheralWithData:L2Header];
}


- (void)writeToPeripheralWithData:(NSData *)data{
    [self writeValue:_peripheral characteristic:_writeCharacteristic data:data];
}

#pragma mark - Notify Characteristic

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        SLLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    CBUUID *UUID = characteristic.UUID;
    NSData *data = characteristic.value;
    
    if (![UUID isEqual:CHARACT_NOTIFY_UUID]) return;
    
    const unsigned char *buf = data.bytes;
    NSMutableString *str = [NSMutableString stringWithString:@""];
    for(NSInteger idx = 0; idx < data.length; idx++) {
        [str appendString:[NSString stringWithFormat:@"%02x", buf[idx]]];
    }
    [DataEnv sharedInstance].receivedStr = str;
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        SLLog(@"Error changing notification state: %@", error.localizedDescription);
    }

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        SLLog(@"写 失败");
        return;
    }
    SLLog(@"写成功");
  
}



- (void)mainBlock:(dispatch_block_t)block{
    dispatch_async(dispatch_get_main_queue(), block);
}


#pragma mark - Disconnect Peripheral
#define ALERT_TYPE 1009

//踢被或防丢后响铃


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.peripheralState = peripheral.state;
    _peripheral.delegate = nil;
    _peripheral = nil;
}

@end