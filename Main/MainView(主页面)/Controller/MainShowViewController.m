//
//  MainShowViewController.m
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import "DetailShowViewController.h"
#import "MainShowViewController.h"
#import "MainShowModel.h"
#import "MainShowView.h"
#import "AppDelegate.h"

#import <Masonry.h>

static NSString * const showDataArchiverPrefix = @"dataArrFile";

@interface MainShowViewController ()

@property (nonatomic, strong) MainShowView *showView;

@property (nonatomic, strong) MainShowModel *showModel;

@end

@implementation MainShowViewController

#pragma mark - cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self unArchiveObject];
    
    [self setBlock];
    [self addShowViewToMainView];
    // Do any additional setup after loading the view.
}

#pragma mark - setBlockAction

/// 设置回调逻辑
- (void)setBlock {
    [self clickTableRow];
    [self setModelBackBlock];
    [self setFreshBolck];
    [self setAppCloseSaveDataBlock];
}

/// 点击tableview的回调
- (void)clickTableRow {
    __weak __typeof(self) weakSelf = self;
    [self.showView setBlock:^(NSInteger indexRow) {
        DetailShowViewController *vc = [[DetailShowViewController alloc] init];
        
        [vc setModel:[weakSelf.showModel getShowModelAtIndex:indexRow]];
        [vc setModelData:weakSelf.showModel withIndex:indexRow];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

/// 数据成功加载的回调
- (void)setModelBackBlock {
    __weak __typeof(self) weakSelf = self;
    self.showModel.backBlock = ^(DataBackState state) {
        if (state == success) {
            [weakSelf setModelToTableView];
        }
    };
}

/// 设置下拉刷新的b回调
- (void)setFreshBolck {
    __weak __typeof(self) weakSelf = self;
    [self.showView setFreshBlock:^{
        [weakSelf.showModel getWebData];
    }];
}

/// 设置app关闭时保存数据的block
- (void)setAppCloseSaveDataBlock {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setSaveDataBlock:^{
        [self archiveObject];
    }];
}

#pragma mark - layout

- (void)addShowViewToMainView {
    [self.view addSubview:self.showView];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - lazy load

- (MainShowView *)showView {
    if (!_showView) {
        _showView = [[MainShowView alloc] init];
    }
    return _showView;
}

#pragma mark - private

/// 将把模型与view绑定
- (void)setModelToTableView {
    [self.showView setModelToTableViewWithModel:self.showModel];
}

#pragma mark - archive / unarchive

- (void)archiveObject {
    if (!self.showModel || self.showModel.getDataNumber == 0) {
        return;
    }
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.showModel requiringSecureCoding:NO error:&error];
    [data writeToFile:[self getPathWithPrefix:showDataArchiverPrefix] atomically:YES];

    if (error) {
        NSLog(@"error");
    }
}

- (void)unArchiveObject {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getPathWithPrefix:showDataArchiverPrefix]];    
    if (data) {
        if (self.showModel = [NSKeyedUnarchiver unarchiveObjectWithData:data]) {
            [self setModelToTableView];
            [self.showModel getWebData];
        }
    }
    
    if (!self.showModel) {
        [self setShowModel:[[MainShowModel alloc] init]];
    }
}

- (NSString *)getPathWithPrefix: (NSString *)prefix {
    // document路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    // 自定义一个文件夹
    NSString *filePathFolder = [documentPath stringsByAppendingPaths:@[@"archiveTemp"]].firstObject;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePathFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePathFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@.archive",filePathFolder,prefix];

    return path;
}

@end
