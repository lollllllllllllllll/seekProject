//
//  MainShowTableViewCell.h
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwipeBlock)(CGFloat result);

@interface MainShowTableViewCell : UITableViewCell

/// 数据模型
@property (nonatomic, strong) ShowModel *model;

@end

NS_ASSUME_NONNULL_END
