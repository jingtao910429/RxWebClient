//
//  RongCloudIMCenterManager.h
//  RongCloudIMManager
//
//  Created by Mac on 2017/8/31.
//  Copyright © 2017年 LiYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RongCloudIMManager.h"

@interface RongCloudIMCenterManager : NSObject

/**
 单例对象
 */
+ (instancetype)manager;

//消息连接
- (void)connect:(void (^)(NSString *userId))successBlock;
//logOut
- (void)logOut;

//更新SDK中的用户信息缓存
- (void)refreshUserInfoCache;

//消息发送
- (void)sendMessageAssociateType:(void (^)(long messageId))successBlock
                           error:(void (^)(RCErrorCode nErrorCode,
                                           long messageId))errorBlock;
- (void)sendTextMessage:(void (^)(long messageId))successBlock
                  error:(void (^)(RCErrorCode nErrorCode,
                                  long messageId))errorBlock;


#pragma mark 链式调用
/** 链式调用 */

- (RongCloudIMCenterManager *(^)(NSString *token))token;
- (RongCloudIMCenterManager *(^)(RCUserInfo *userInfo, NSString *userId))refreshCache;

- (RongCloudIMCenterManager *(^)(RCMessageContent *content,
                                 RCUserInfo *userInfo,
                                 NSString *targetId))sendMessageAssociateType;
- (RongCloudIMCenterManager *(^)(NSString *targetId,
                                 RCUserInfo *userInfo,
                                 RCMessageContent *content,
                                 NSString *pushContent,
                                 NSString *pushData))sendMessages;
- (RongCloudIMCenterManager *(^)(NSString *targetId,
                                   RCUserInfo *userInfo,
                                   RCMessageContent *content,
                                   NSString *extra))sendTextMessage;
- (RongCloudIMCenterManager *(^)(NSString *userId,
                                 RCUserInfo *userInfo,
                                 RCMessageContent *content,
                                 NSInteger houseId,
                                 NSString *houseName))sendMsgToServer;

- (RongCloudIMCenterManager *(^)(NSString *userId,
                                 RCMessageContent *content,
                                 NSInteger houseId,
                                 NSString *houseName))chat;


@end
