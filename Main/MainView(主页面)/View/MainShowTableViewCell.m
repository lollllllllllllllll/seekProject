//
//  MainShowTableViewCell.m
//  Seek
//
//  Created by 任玉乾 on 2020/2/19.
//  Copyright © 2020 REN. All rights reserved.
//

#import "ShowModel.h"
#import "MainShowTableViewCell.h"

#import <SDWebImage.h>
#import <Masonry.h>

@interface MainShowTableViewCell()

@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, strong) UILabel *infoLab;

@end

@implementation MainShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self viewSettingAction];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - layout

- (void)layoutSubviews {
    [self addSubview:self.showImageView];
    [self addSubview:self.infoLab];
    
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(50);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(_showImageView.mas_height).multipliedBy(1);
    }];
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.right.equalTo(self).offset(-10);
        make.left.equalTo(self.showImageView.mas_right).offset(10);
    }];
}

#pragma mark - setter

- (void)setModel:(ShowModel *)model {
    if (model) {
        _model = model;
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_model.showImageUrl]];
        [self.infoLab setText:_model.detailInfo];
    }
}

#pragma mark - lazy load

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.numberOfLines = 0;
    }
    return _infoLab;
}

#pragma mark - private func

- (void)viewSettingAction {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
