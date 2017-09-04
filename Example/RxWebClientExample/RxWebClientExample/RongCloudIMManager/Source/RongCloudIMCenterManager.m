//
//  RongCloudIMCenterManager.m
//  RongCloudIMManager
//
//  Created by Mac on 2017/8/31.
//  Copyright © 2017年 LiYou. All rights reserved.
//

#import "RongCloudIMCenterManager.h"
#import "RongCloudIMDataRequest.h"

@interface RongCloudIMCenterManager ()

@property (nonatomic, strong) RongCloudIMDataRequest *dataRequest;

- (void)sendMessages:(void (^)(long messageId))successBlock
                  error:(void (^)(RCErrorCode nErrorCode,
                                  long messageId))errorBlock;
@end

@implementation RongCloudIMCenterManager

+ (instancetype)manager {
    static id _shared;
    static dispatch_once_t onceInstance;
    dispatch_once(&onceInstance, ^{
        _shared = [[RongCloudIMCenterManager alloc] init];
    });
    return _shared;
}

- (RongCloudIMCenterManager *(^)(NSString *))token {
    return ^ RongCloudIMCenterManager *(NSString *token) {
        self.dataRequest.token = token;
        return self;
    };
}

- (RongCloudIMCenterManager *(^)(RCUserInfo *, NSString *))refreshCache {
    return ^RongCloudIMCenterManager *(RCUserInfo *userInfo, NSString *userId) {
        self.dataRequest.userInfo = userInfo;
        self.dataRequest.userId = userId;
        return self;
    };
}

- (RongCloudIMCenterManager *(^)(RCMessageContent *, RCUserInfo *, NSString *))sendMessageAssociateType {
    return ^RongCloudIMCenterManager *(RCMessageContent *content, RCUserInfo *userInfo, NSString *targetId) {
        self.dataRequest.content = content;
        self.dataRequest.userInfo = userInfo;
        self.dataRequest.content.senderUserInfo = userInfo;
        self.dataRequest.targetId = targetId;
        return self;
    };
}

- (RongCloudIMCenterManager *(^)(NSString *, RCUserInfo *, RCMessageContent *, NSString *, NSString *))sendMessages {
    return ^RongCloudIMCenterManager *(NSString *targetId, RCUserInfo *userInfo, RCMessageContent *content, NSString *pushContent, NSString *pushData) {
        self.dataRequest.targetId = targetId;
        self.dataRequest.userInfo = userInfo;
        self.dataRequest.content = content;
        self.dataRequest.pushContent = pushContent;
        self.dataRequest.pushData = pushData;
        return self;
    };
}

- (RongCloudIMCenterManager *(^)(NSString *, RCUserInfo *, RCMessageContent *, NSString *))sendTextMessage {
    return ^RongCloudIMCenterManager *(NSString *targetId, RCUserInfo *userInfo, RCMessageContent *content, NSString *extra) {
        self.dataRequest.targetId = targetId;
        self.dataRequest.userInfo = userInfo;
        self.dataRequest.content = content;
        self.dataRequest.extra = extra;
        return self;
    };
}

- (RongCloudIMCenterManager *(^)(NSString *, RCUserInfo *, RCMessageContent *, NSInteger, NSString *))sendMsgToServer {
    
    return ^RongCloudIMCenterManager *(NSString *userId, RCUserInfo *userInfo, RCMessageContent *content, NSInteger houseId, NSString *houseName) {
        self.dataRequest.userId = userId;
        self.dataRequest.userInfo = userInfo;
        self.dataRequest.content = content;
        self.dataRequest.houseId = houseId;
        self.dataRequest.houseName = houseName;
        return self;
    };
    
}

- (RongCloudIMCenterManager *(^)(NSString *, RCMessageContent *, NSInteger, NSString *))chat {
    
    return ^RongCloudIMCenterManager *(NSString *userId, RCMessageContent *content, NSInteger houseId, NSString *houseName) {
        self.dataRequest.userId = userId;
        self.dataRequest.content = content;
        self.dataRequest.houseId = houseId;
        self.dataRequest.houseName = houseName;
        return self;
    };
    
}

#pragma mark - Result Config

- (void)connect:(void (^)(NSString *))successBlock {
    [[RCIM sharedRCIM] connectWithToken:self.dataRequest.token success:^(NSString *userId) {
        if (userId != nil) {
            successBlock(userId);
        } else {
            NSLog(@"userId无法获取");
        }
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为%ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"token 错误");
    }];
}

- (void)logOut {
    [[RCIM sharedRCIM] logout];
}


#pragma mark - Cache

- (void)refreshUserInfoCache {
    [[RCIM sharedRCIM] refreshUserInfoCache:self.dataRequest.userInfo withUserId:self.dataRequest.userId];
}


#pragma mark - Message About

- (void)sendMessageAssociateType:(void (^)(long))successBlock error:(void (^)(RCErrorCode, long))errorBlock {
    
    [self sendMessages:^(long messageId) {
        successBlock(messageId);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        errorBlock(nErrorCode, messageId);
    }];
    
}

- (void)sendTextMessage:(void (^)(long))successBlock error:(void (^)(RCErrorCode, long))errorBlock {
    
}

- (void)sendMessages:(void (^)(long))successBlock error:(void (^)(RCErrorCode, long))errorBlock {
    
}


//#pragma mark - Result Config
//#ifdef RAC
//+ (void)setupResponseSignalWithFlattenMapBlock:(RongCloudIMFlattenMapBlock)flattenMapBlock {
//    _flattenMapBlock = flattenMapBlock;
//}
//#endif
//
//#ifdef RAC
//
//- (RACSignal *)connectExecuteSignal {
//    return [self rac_connect];
//}
//
//- (RACSignal *)rac_connect {
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        [[RCIM sharedRCIM] connectWithToken:self.dataRequest.token success:^(NSString *userId) {
//            if (userId != nil) {
//                [subscriber sendNext:userId];
//            } else {
//                NSLog(@"userId无法获取");
//                [subscriber sendCompleted];
//            }
//        } error:^(RCConnectErrorCode status) {
//            NSLog(@"登陆的错误码为%ld",(long)status);
//            [subscriber sendError:[NSError errorWithDomain:@"" code:500 userInfo:nil]];
//        } tokenIncorrect:^{
//            NSLog(@"token 错误");
//            [subscriber sendCompleted];
//        }];
//        
//        return nil;
//    }];
//    
//    return signal;
//}
//
//- (RACSignal *)logoutExecuteSignal {
//    return [self rac_logout];
//}
//
//- (RACSignal *)rac_logout {
//    RACSignal *logoutSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [[RCIM sharedRCIM] logout];
//        return nil;
//    }];
//    return logoutSignal;
//}
//
//- (RACSignal *)executeSignal {
//    
//    RACSignal *resultSignal = [self rac_sendMessages:self.dataRequest];
//    if (_flattenMapBlock) return [resultSignal flattenMap:_flattenMapBlock];
//    
//    return resultSignal;
//}
//
//- (RACSignal *)sendMessagesExecuteSignal {
//    RACSignal *resultSignal = [self rac_sendMessages:self.dataRequest];
//    if (_flattenMapBlock) return [resultSignal flattenMap:_flattenMapBlock];
//    return resultSignal;
//}
//
//- (RACSignal *)sendMsgToServerExecuteSignal {
//    RACSignal *resultSignal = [self rac_sendMsgToServer:self.dataRequest];
//    if (_flattenMapBlock) return [resultSignal flattenMap:_flattenMapBlock];
//    return resultSignal;
//}
//
//- (RACSignal *)rac_sendMessages:(RongCloudIMDataRequest *)dataRequest {
//    
//    @weakify(self);
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.dataRequest.targetId content:self.dataRequest.content pushContent:self.dataRequest.pushContent pushData:self.dataRequest.pushData success:^(long messageId) {
//            NSLog(@"send success");
//            
//            @strongify(self);
//            [[self rac_sendMsgToServer:self.dataRequest] subscribeNext:^(id result) {
//                [subscriber sendNext:result];
//            } error:^(NSError *error) {
//                [subscriber sendError:error];
//            } completed:^{
//                [subscriber sendCompleted];
//            }];
//            
//        } error:^(RCErrorCode nErrorCode, long messageId) {
//            [subscriber sendError:[NSError errorWithDomain:@"" code:nErrorCode userInfo:nil]];
//        }];
//        return nil;
//    }];
//    
//    return signal;
//}
//
//- (RACSignal *)rac_sendMsgToServer:(RongCloudIMDataRequest *)dataRequest {
//    
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        return nil;
//    }];
//    
//    return signal;
//}
//
//- (RACSignal *)rac_addChat:(RongCloudIMDataRequest *)dataRequest {
//    
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        return nil;
//    }];
//    
//    return signal;
//}
//
//#endif

#pragma mark - Getters & Setters

- (RongCloudIMDataRequest *)dataRequest {
    if (!_dataRequest) {
        _dataRequest = [[RongCloudIMDataRequest alloc] init];
    }
    return _dataRequest;
}

@end
