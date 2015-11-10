//
//  blocktypedef.h
//  Vaccine
//
//  Created by Tonny on 12-12-9.
//  Copyright (c) 2012年 DoouYa All rights reserved.
//

#ifndef Vaccine_blocktypedef_h
#define Vaccine_blocktypedef_h

typedef void(^DYBlock)(void);
typedef void(^DYBlockBlock)(DYBlock block);
typedef void(^DYObjectBlock)(id obj);
typedef void(^DYTwoObjectBlock)(id obj, id obj1);
typedef void(^DYBOOLBlock)(BOOL obj);
typedef void(^DYArrayBlock)(NSArray *array);
typedef void(^DYMutableArrayBlock)(NSMutableArray *array);
typedef void(^DYDictionaryBlock)(NSDictionary *dic);
typedef void(^DYErrorBlock)(NSError *error);
typedef void(^DYIndexBlock)(NSInteger index);
typedef void(^DYFloatBlock)(float afloat);

typedef void(^DYCancelBlock)(id viewController);
typedef void(^DYFinishedBlock)(id viewController, id object);

typedef void(^DYSendRequestAndResendRequestBlock)(id sendBlock, id resendBlock);

#endif
