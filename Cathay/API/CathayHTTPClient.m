//
//  CathayHTTPClient.m
//  Cathay
//
//  Created by Nic on 2018/11/18.
//  Copyright © 2018 Nic. All rights reserved.
//

#import "CathayHTTPClient.h"

@implementation CathayHTTPClient

+(CathayHTTPClient *) sharedInstance {
  static CathayHTTPClient *_sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[CathayHTTPClient alloc] init];
  });
 
  return _sharedInstance;
}


- (void)fetchAnimalData:(NSString *)urlString completion:(CathayHTTPClientLoginCompletionBlock)completion {
  
  NSURL *dataURL = [NSURL URLWithString:urlString];
  NSURLSessionTask *task =[[NSURLSession sharedSession] dataTaskWithURL:dataURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (!error) {
        NSDictionary *responseObject  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(YES, responseObject);
        });
      } else {
          completion(NO, response);
      }
    }];
  [task resume];
}

- (void)fetchImage:(NSString *)urlString completion:(CathayHTTPClientLoginCompletionBlock)completion{
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (!error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(YES, data);
      });
    } else {
      completion(NO, response);
    }
  }];
  [task resume];
}

@end
