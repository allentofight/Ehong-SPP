//
//  ViewController.m
//  Ehong-SPP
//
//  Created by ronaldo on 11/10/15.
//  Copyright © 2015 ronaldo. All rights reserved.
//

#import "ViewController.h"
#import "TBBluetoothCentraManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CONSTANTS.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataEnv.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tempFCSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lockenSwitch;
@property (weak, nonatomic) IBOutlet UILabel *tempSetLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeNowLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeSetLbl;
@property (weak, nonatomic) IBOutlet UIButton *recvBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *receiveLbl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TBBluetoothCentraManager *bluetoothManager = [TBBluetoothCentraManager sharedInstance];
    [[RACObserve(bluetoothManager, peripheralState) deliverOn:[RACScheduler mainThreadScheduler]]  subscribeNext:^(NSNumber *state) {
        _stateLbl.text = @"disconnected";
        _recvBtn.enabled = false;
        _sendBtn.enabled = false;
        _recvBtn.alpha = 0.5;
        _sendBtn.alpha = 0.5;
        if ([state integerValue] == CBPeripheralStateConnected) {
            _stateLbl.text = @"connected";
            _recvBtn.enabled = true;
            _sendBtn.enabled = true;
            _recvBtn.alpha = 1;
            _sendBtn.alpha = 1;
        }
    }];
    
    
    [[RACObserve([DataEnv sharedInstance], receivedStr) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSString *receivedStr) {
        _receiveLbl.text = receivedStr;
    }];
}

- (IBAction)sendBtnPressed:(id)sender {
    [[TBBluetoothCentraManager sharedInstance] sendTestBytes];
    [SVProgressHUD showInfoWithStatus:@"已发送" maskType:SVProgressHUDMaskTypeBlack];
}

- (IBAction)read:(id)sender {
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
