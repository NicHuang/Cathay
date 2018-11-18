//
//  CathayAnimal.h
//  Cathay
//
//  Created by Nic on 2018/11/18.
//  Copyright © 2018 Nic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CathayAnimal : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *behavior;
@property (strong, nonatomic) NSString *imageURL;

+ (NSArray *)insertJsonIntoAnimals:(NSArray *) animals;

@end

NS_ASSUME_NONNULL_END
