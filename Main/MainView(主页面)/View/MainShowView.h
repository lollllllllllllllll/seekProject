//
//  MainShowView.h
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainShowModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickBlock)(NSInteger indexRow);

typedef void(^refreshBlock)(void);

@interface MainShowView : UIView

/// 点击事件的回调
@property (nonatomic, copy) clickBlock block;

/// 下滑更新block
@property (nonatomic, copy) refreshBlock freshBlock;

/// 设置模型数据
/// @param showModel MainShowModel
- (void)setModelToTableViewWithModel:(MainShowModel *)showModel;

@end

NS_ASSUME_NONNULL_END
