//
//  DataEnv.h
//  Ehong-SPP
//
//  Created by ronaldo on 11/10/15.
//  Copyright © 2015 ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataEnv : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, copy) NSString *receivedStr;
@end
