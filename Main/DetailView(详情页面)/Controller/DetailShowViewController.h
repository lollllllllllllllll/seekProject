//
//  DetailShowViewController.h
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowModel;
@class MainShowModel;

NS_ASSUME_NONNULL_BEGIN

@interface DetailShowViewController : UIViewController

/// 设置显示的模型数据
/// @param model ShowModel
- (void)setModel:(ShowModel *)model;

/// 设置总数据
/// @param modelData 全部数据
/// @param index 选中下标
- (void)setModelData:(MainShowModel *)modelData withIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
