//
//  CathayAnimal.m
//  Cathay
//
//  Created by Nic on 2018/11/18.
//  Copyright © 2018 Nic. All rights reserved.
//

#import "CathayAnimal.h"

@implementation CathayAnimal


- (id) initWithAnimal:(NSString *) animalName{
  
  self = [super init];
  
  if (self) {
    _name = animalName;
    _behavior = nil;
    _location = nil;
    _imageURL = nil;
  }
  
  return self;
}

+ (id) animalWithName:(NSString *) animal{
  
  return [[self alloc] initWithAnimal:animal];
  
}


+ (NSArray *)insertJsonIntoAnimals:(NSArray *) animals{
  
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:animals.count];
  
  [animals enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
    
    CathayAnimal *animal = [self animalWithName:dict[@"A_Name_Ch"]];
    animal.location = dict[@"A_Location"];
    animal.behavior = [dict[@"A_Behavior"] isEqualToString:@""] ? dict[@"A_Interpretation"]:dict[@"A_Behavior"];
    animal.imageURL = dict[@"A_Pic01_URL"];
    [array addObject:animal];
  }];
  
  return array;
}


@end
