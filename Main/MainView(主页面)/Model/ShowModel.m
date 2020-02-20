//
//  ShowModel.m
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import "ShowModel.h"

@interface ShowModel()

@end

@implementation ShowModel

#pragma mark - coder

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _showImageUrl = [coder decodeObjectForKey:@"showImageUrl"];
        _detailInfo = [coder decodeObjectForKey:@"detailInfo"];
        _gradeNumber = [coder decodeObjectForKey:@"gradeNumber"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.showImageUrl forKey:@"showImageUrl"];
    [coder encodeObject:self.detailInfo forKey:@"detailInfo"];
    [coder encodeObject:self.gradeNumber forKey:@"gradeNumber"];
}

#pragma mark - lazy load

- (NSNumber *)gradeNumber {
    if (!_gradeNumber) {
        _gradeNumber = [NSNumber numberWithInt:0];
    }
    return _gradeNumber;
}

- (NSString *)showImageUrl {
    if (!_showImageUrl) {
        _showImageUrl = @"null";
    }
    return _showImageUrl;
}

- (NSString *)detailInfo {
    if (!_detailInfo) {
        _detailInfo = @"null";
    }
    return _detailInfo;
}

@end
