//
//  CathayTableViewCell.h
//  Cathay
//
//  Created by Nic on 2018/11/18.
//  Copyright © 2018 Nic. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CathayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *aniImageView;
@property (weak, nonatomic) IBOutlet UILabel *aniNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aniLocation;
@property (weak, nonatomic) IBOutlet UILabel *aniBehavior;

@end

NS_ASSUME_NONNULL_END
