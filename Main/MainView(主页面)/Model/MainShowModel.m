//
//  MainShowModel.m
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import "MainShowModel.h"
#import "ShowModel.h"

#import <AFNetworking.h>

@interface MainShowModel ()<NSCoding>

@property (nonatomic, strong) NSMutableArray<ShowModel *> *dataArr;

@end

@implementation MainShowModel

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self getWebData];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:self.dataArr forKey:@"dataArr"];
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder {

    if (self = [super init]) {
        self.dataArr = [aDecoder decodeObjectForKey:@"dataArr"];
    }
    return self;
}

#pragma mark - public Func

- (NSUInteger)getDataNumber {
    return self.dataArr.count;
}

- (ShowModel *)getShowModelAtIndex:(NSUInteger)index {
    if (self.dataArr.count > index) {
        return [self.dataArr objectAtIndex:index];
    }
    return nil;
}

#pragma mark - webService

/// 获取网络数据
- (void)getWebData {
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];

    __weak __typeof(self) weakSelf = self;
    [manager GET:@"http://v.juhe.cn/toutiao/index?type=shehui&key=694455ec2df292a47d2660fdd2d9cf5b" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           ///获取数据
           NSArray *arr = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"data"];
           [weakSelf dataAnalysisWithArrData:arr];
           
           /// 通过回调告知数据返回成功
           if (weakSelf.backBlock) {
               weakSelf.backBlock(success);
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           /// 通过回调告知数据返回失败
           if (weakSelf.backBlock) {
               weakSelf.backBlock(failed);
           }
       }];
}

#pragma mark - webDataAnalysis

/// 解析数组
/// @param data 网络读取的数组
- (void)dataAnalysisWithArrData:(NSArray *)data {
    [self.dataArr removeAllObjects];
    for (int i = 0; i < data.count; i++) {
        NSDictionary *showData = data[i];
        NSString *info = [showData objectForKey:@"title"];
        NSString *imageUrl = [showData objectForKey:@"thumbnail_pic_s"];
        
        ShowModel *model = [[ShowModel alloc] init];
        model.detailInfo = info;
        model.showImageUrl = imageUrl;
        model.gradeNumber = [NSNumber numberWithInt:0];
        
        [self.dataArr addObject:model];
    }
}

#pragma mark - lazy load

- (NSMutableArray<ShowModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
