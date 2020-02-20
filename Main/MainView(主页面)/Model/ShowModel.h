//
//  ShowModel.h
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowModel : NSObject

/// 图片url
@property (nonatomic, copy) NSString *showImageUrl;

/// 详细信息
@property (nonatomic, copy) NSString *detailInfo;

/// 评价分数
@property (nonatomic, strong) NSNumber *gradeNumber;

@end

NS_ASSUME_NONNULL_END
