//
//  MainShowModel.h
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShowModel;

typedef NS_ENUM(NSInteger, DataBackState) {
    success = 0, //数据返回成功
    failed = 1,  //数据返回失败
};

typedef void(^dataBackBlock)(DataBackState state);

NS_ASSUME_NONNULL_BEGIN

@interface MainShowModel : NSObject

@property (nonatomic, copy) dataBackBlock backBlock;

/// 获取数据的数量用来确定cell的行数
- (NSUInteger)getDataNumber;

/// 获取网络数据
- (void)getWebData;

/// 获取对应cell的数据
/// @param index 对应cell的row
- (ShowModel *)getShowModelAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
