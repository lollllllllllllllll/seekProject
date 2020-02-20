//
//  MainShowView.m
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import "ShowModel.h"
#import "MainShowView.h"
#import "MainShowModel.h"
#import "XHStarRateView.h"
#import "MainShowTableViewCell.h"

#import <SDWebImage.h>
#import <Masonry.h>

@interface MainShowView () <UITableViewDelegate, UITableViewDataSource>

/// 横屏和竖屏时候 显示的tableview
@property (nonatomic, strong) UITableView *tableView;

/// 横屏时显示的图片
@property (nonatomic, strong) UIImageView *showImageView;

/// 横屏时显示的详情信息
@property (nonatomic, strong) UILabel *detailInfoLab;

/// 评星控件
@property (nonatomic, strong) XHStarRateView *starView;

/// 用来显示的数据
@property (nonatomic, strong) MainShowModel *showModel;

/// 当前选中的cell下标
@property (nonatomic, assign) NSUInteger selectIndex;

@end

@implementation MainShowView

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        
        [self addSubview:self.tableView];
        [self addSubview:self.showImageView];
        [self addSubview:self.detailInfoLab];
        [self addSubview:self.starView];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self postNotice];
    
    return self;
}

#pragma mark - tableView Delegate / DataSoure

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"myCell";
    MainShowTableViewCell *cell = (MainShowTableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:identify];
    
    if (!cell) {
        cell = [[MainShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [cell setModel:[self.showModel getShowModelAtIndex:indexPath.row]];
       
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showModel.getDataNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self getPortrait]) {
        if (self.block) {
            self.block(indexPath.row);
        }
    }
    [self setSelctModelAtIndex:indexPath.row];
}

#pragma mark - post notice



/// 注册屏幕变化通知
- (void)postNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

/// 屏幕变化完成的通知
/// @param noti  NSNotification
- (void)changeRotate:(NSNotification*)noti {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - layout

- (void)layoutSubviews {
    
    [self.starView setUpShowStarScore:[self.showModel getShowModelAtIndex:self.selectIndex].gradeNumber.floatValue];
    
    if([self getPortrait]) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.equalTo(self).offset(0);
        }];
        
        self.showImageView.hidden   = YES;
        self.detailInfoLab.hidden   = YES;
        self.starView.hidden        = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataArchiver" object:nil userInfo:nil];
    } else {
        self.showImageView.hidden   = NO;
        self.detailInfoLab.hidden   = NO;
        self.starView.hidden        = NO;
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self).offset(0);
            make.width.offset(450);
        }];
                
        [self.showImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_showImageView.mas_height).multipliedBy(1);
            make.top.equalTo(self).offset(60);
            make.left.equalTo(self.tableView.mas_right).offset(120);
            make.right.equalTo(self).offset(-100);
        }];
        
        [self.detailInfoLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.showImageView.mas_bottom).offset(10);
            make.width.left.equalTo(self.showImageView);
            make.height.offset(60);
        }];
    }
}

#pragma mark - lazy load
///TODO: 删除测试数据
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UILabel *)detailInfoLab {
    if (!_detailInfoLab) {
        _detailInfoLab = [[UILabel alloc] init];
        _detailInfoLab.textAlignment = NSTextAlignmentCenter;
        _detailInfoLab.numberOfLines = 0;
    }
    return _detailInfoLab;
}

- (XHStarRateView *)starView {
    if (!_starView) {
        __weak __typeof(self) weakSelf = self;
        _starView = [[XHStarRateView alloc] initWithFrame:CGRectMake([UIScreen mainScreen ].bounds.size.height/2 + 135, 10, 200, 40) numberOfStars:5 rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
            //处理回调
            [[weakSelf.showModel getShowModelAtIndex:weakSelf.selectIndex] setGradeNumber:[NSNumber numberWithFloat:currentScore]];
        }];
    }
    return _starView;
}

#pragma mark - public func

- (void)setModelToTableViewWithModel:(MainShowModel *)showModel {
    self.showModel = showModel;
    if ([self.showModel getDataNumber] > 0) {
        [self setSelctModelAtIndex:0];
        self.selectIndex = 0;
    }
    [self.tableView reloadData];
}

#pragma mark - private func

/// 返回当前屏幕状态，若当前为竖屏返回ture，反之返回false
- (BOOL)getPortrait {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
            || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        return true;
    } else {
        return false;
    }
}

/// 显示横屏的数据
/// @param index 点击cell的行号
- (void)setSelctModelAtIndex:(NSUInteger)index {
    ShowModel *tmodel = [self.showModel getShowModelAtIndex:index];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:tmodel.showImageUrl]];
    [self.detailInfoLab setText:tmodel.detailInfo];
    [self.starView setUpShowStarScore:tmodel.gradeNumber.floatValue];
    [self setSelectIndex:index];
}

@end
