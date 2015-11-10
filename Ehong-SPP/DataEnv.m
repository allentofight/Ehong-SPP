//
//  DataEnv.m
//  Ehong-SPP
//
//  Created by ronaldo on 11/10/15.
//  Copyright © 2015 ronaldo. All rights reserved.
//

#import "DataEnv.h"

@implementation DataEnv
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
