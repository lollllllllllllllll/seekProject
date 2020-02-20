//
//  AppDelegate.h
//  Seek
//
//  Created by 任玉乾 on 2020/2/18.
//  Copyright © 2020 REN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AllowRotation) {
    allMask             = 0,    //横屏竖屏皆可
    onlyMaskPortrait    = 1,    //只能竖屏
};

typedef void(^SaveDataBlock)(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// 控制横屏竖屏的便利
@property (nonatomic, assign) AllowRotation allowRotation;

/// app关闭时数据保存的block
@property (nonatomic, copy) SaveDataBlock saveDataBlock;

@end

