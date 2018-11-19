//
//  CathayNavigationBar.m
//  Cathay
//
//  Created by Nic on 2018/11/14.
//  Copyright © 2018 Nic. All rights reserved.
//

#import "CathayNavigationBar.h"

@implementation CathayNavigationBar {
  CGFloat extendedBarHeight;
}

- (CGSize)sizeThatFits:(CGSize)size {
  
  CGSize sizeThatFit = [super sizeThatFits:size];
  if ([UIApplication sharedApplication].isStatusBarHidden) {
    if (sizeThatFit.height < 64.f) {
      sizeThatFit.height = 90.f;
    }
  }
  return sizeThatFit;
}

- (void)setShyBarHeight:(CGFloat)shyBarHeight {
  
}

- (void)setFullBarHeight:(CGFloat)fullBarHeight {
  
}

- (void)setFrame:(CGRect)frame {

  NSLog(@"dd");
}



- (void)layoutSubviews {
  
  [super layoutSubviews];
//
//  extendedBarHeight = 64.0f;
//  UIView *extendedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 64)];
//  extendedView.backgroundColor = [UIColor redColor];
//  [self addSubview:extendedView];
}


@end
