//
//  DetailShowViewController.m
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import "ShowModel.h"
#import "AppDelegate.h"
#import "MainShowModel.h"
#import "XHStarRateView.h"
#import "DetailShowViewController.h"

#import <SDWebImage.h>

@interface DetailShowViewController ()

/// 评星控件
@property (nonatomic, strong) XHStarRateView *starRateView;

/// 显示图片
@property (nonatomic, strong) UIImageView *showImageView;

/// 显示信息详情
@property (nonatomic, strong) UILabel *infoLab;

/// 当前显示的数据模型
@property (nonatomic, strong) ShowModel *model;

/// 用来加载下一个数据模型
@property (nonatomic, strong) MainShowModel *modelData;

/// 选择的数据模型下标
@property (nonatomic, assign) NSUInteger selectIndex;

/// 左滑手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;

/// 右滑手势
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;

@end

@implementation DetailShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewSettingAction];
    [self loadGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = onlyMaskPortrait;
}

- (void)viewDidDisappear:(BOOL)animated {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = allMask;
}

#pragma mark - lazy load

- (XHStarRateView *)starRateView {
    if (!_starRateView) {
        __weak __typeof(self) weakSelf = self;
        _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 50) numberOfStars:5 rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
            [weakSelf.model setGradeNumber:[NSNumber numberWithFloat:currentScore]];
        }];
    }
    return _starRateView;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.userInteractionEnabled = YES;
        _showImageView.frame = CGRectMake(20, 90, self.view.frame.size.width - 40, self.view.frame.size.width - 40);
    }
    return _showImageView;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.frame = CGRectMake(20, self.view.frame.size.width + 70, self.view.frame.size.width - 40, 50);
        _infoLab.numberOfLines = 0;
    }
    return _infoLab;
}

#pragma mark - load Gesture

- (void)loadGesture {
    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.showImageView addGestureRecognizer:self.leftSwipe];
    [self.showImageView addGestureRecognizer:self.rightSwipe];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)gesture {
    CGFloat result = 0;
    if ([gesture isEqual:self.leftSwipe]) {
        result = 0;
        if (self.selectIndex < self.modelData.getDataNumber - 1) {
            self.selectIndex += 1;
        }
    } else if ([gesture isEqual:self.rightSwipe]) {
        result = 5;
        if (self.selectIndex > 0) {
            self.selectIndex += -1;
        }
    }
    
    [self.model setGradeNumber:[NSNumber numberWithFloat:result]];
    [self setModel:[self.modelData getShowModelAtIndex:self.selectIndex]];
}

#pragma mark - private func

/// 设置view
- (void)viewSettingAction {
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.starRateView];
    [self.view addSubview:self.showImageView];
    [self.view addSubview:self.infoLab];
}

#pragma mark - public func

- (void)setModel:(ShowModel *)model {
    if (model) {
        _model = model;
        [self.infoLab setText:model.detailInfo];
        [self.starRateView setUpShowStarScore:model.gradeNumber.floatValue];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.showImageUrl]];
    }
}

- (void)setModelData:(MainShowModel *)modelData withIndex:(NSUInteger)index {
    if (modelData) {
        _modelData = modelData;
        _selectIndex = index;
    }
}

@end
