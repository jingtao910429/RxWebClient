//
//  RongCloudIMDataStore.h
//  RongCloudIMManager
//
//  Created by Mac on 2017/8/31.
//  Copyright © 2017年 LiYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RongCloudIMManager.h"

@interface RongCloudIMDataRequest : NSObject

@property (nonatomic, copy)   NSString *token;

@property (nonatomic, copy)   NSString *targetId;
@property (nonatomic, copy)   RCUserInfo *userInfo;
@property (nonatomic, strong) RCMessageContent *content;
@property (nonatomic, copy)   NSString *pushContent;
@property (nonatomic, copy)   NSString *pushData;
@property (nonatomic, copy)   NSString *extra;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, assign) NSInteger houseId;
@property (nonatomic, copy)   NSString *houseName;
@end
