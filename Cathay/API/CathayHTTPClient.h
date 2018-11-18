//
//  CathayHTTPClient.h
//  Cathay
//
//  Created by Nic on 2018/11/18.
//  Copyright © 2018 Nic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CathayHTTPClientLoginCompletionBlock)(BOOL success, id responseObject);

@interface CathayHTTPClient : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

+(CathayHTTPClient *)sharedInstance;

- (void)fetchAnimalData:(NSString *)urlString completion:(CathayHTTPClientLoginCompletionBlock)completion;
- (void)fetchImage:(NSString *)urlString completion:(CathayHTTPClientLoginCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
