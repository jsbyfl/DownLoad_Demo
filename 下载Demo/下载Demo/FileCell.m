
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell{
    UILabel *_fileNameLab;
    UIImageView *_statusImgV;
    
    FileModel *_fileInfo;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *_v = [[UIView alloc] init];
        self.selectedBackgroundView = _v;
        
        
        _cellHeight = 80;
        CGFloat _wImgv = 50;
        CGFloat _xlabel = _wImgv;
        CGFloat _Wbtn = 80;
        CGFloat _wlabel = CGRectGetWidth(self.frame) - _xlabel - _Wbtn;
        

        _statusImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _wImgv, _cellHeight)];
        _statusImgV.image = [UIImage imageNamed:@"ic_edit_normal.png"];
        _statusImgV.contentMode = UIViewContentModeCenter;
        _statusImgV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_statusImgV];
        _statusImgV.hidden = YES;
        
        
        _fileNameLab = [[UILabel alloc] initWithFrame:CGRectMake(_xlabel, 15, _wlabel, 50)];
        _fileNameLab.backgroundColor = [UIColor clearColor];
        _fileNameLab.textAlignment = NSTextAlignmentLeft;
        _fileNameLab.numberOfLines = 0;
        _fileNameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
//        _fileNameLab.font = FONT_(16);
//        _fileNameLab.textColor = COLOR_BLACK_01;
        _fileNameLab.tag = 100;
        [self.contentView addSubview:_fileNameLab];
        
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat _y_downbtn = 15;
        _downBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - _Wbtn, _y_downbtn, _Wbtn, _cellHeight - 2*_y_downbtn);
        [_downBtn setImage:[UIImage imageNamed:@"ic_down_normal"] forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"ic_down_high"] forState:UIControlStateHighlighted];
        [_downBtn setTitle:@"下载" forState:UIControlStateNormal];
//        [_downBtn setTitleColor:COLOR_BLACK_02 forState:UIControlStateNormal];
//        [_downBtn setTitleColor:MAINCOLOR forState:UIControlStateHighlighted];
        _downBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _downBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _downBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _downBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_downBtn];
        

        _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_fileNameLab.frame) + 10, Screen_Width - 10, 10)];
//        _progressView.color = MAINCOLOR_Price;
        _progressView.flat = @YES;
        _progressView.progress = 0;
        _progressView.animate = @YES;
        _progressView.hidden = YES;
        _progressView.tag = 888;
        [self.contentView addSubview:_progressView];
        
        _indicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorV.frame = CGRectMake(0, 0, _wImgv,_cellHeight);
        _indicatorV.backgroundColor = [UIColor clearColor];
//        _indicatorV.color = MAINCOLOR;
        _indicatorV.hidesWhenStopped = NO;
        [self.contentView addSubview:_indicatorV];
        _indicatorV.hidden = YES;
        
        
        _cellHeight = CGRectGetMaxY(_progressView.frame) + 10;
    }
    return self;
}

-(FileModel *)fileInfo{
    return _fileInfo;
}

-(void)setFileInfo:(FileModel *)fileInfo{
    _fileInfo = fileInfo;
    [self updateCell:fileInfo.downStatus];

    _fileNameLab.text = fileInfo.downUrlString;
//    _fileSizeLab.text = [FileHelper getFileSizeString:fileInfo.size];
}


-(void)updateCell:(DownloadStatus)downStatus{
    
    NSString *imgName = nil;
    NSString *downName = nil;
    NSString *imgDown = nil;
    NSString *imgDownHigh = nil;
    
    if (downStatus == DownloadStatusNotDown) {
        imgName = @"ic_notDonw";
        downName = @"下载";
        imgDown = @"ic_down_normal";
        imgDownHigh = @"ic_down_high";
        _progressView.hidden = YES;
        _progressView.progress = 0;
        _statusImgV.hidden = NO;
        
        if (_indicatorV.isAnimating) {
            [_indicatorV stopAnimating];
        }
        _indicatorV.hidden = YES;
        
    }else if (downStatus == DownloadStatusDowning) {
        imgName = @"ic_downing";
        downName = @"取消";
        imgDown = @"ic_downCancle_normal";
        imgDownHigh = @"ic_downCancle_high";
        _progressView.hidden = NO;
        _statusImgV.hidden = YES;
        
        if (!_indicatorV.isAnimating) {
            [_indicatorV startAnimating];
        }
        _indicatorV.hidden = NO;
        
    }else{
        imgName = @"ic_downFinished";
        downName = @"下载";
        imgDown = @"ic_down_normal";
        imgDownHigh = @"ic_down_high";
        _progressView.hidden = YES;
        _progressView.progress = 0;
        _statusImgV.hidden = NO;

        if (_indicatorV.isAnimating) {
            [_indicatorV stopAnimating];
        }
        _indicatorV.hidden = YES;
    }
    
    _statusImgV.image = [UIImage imageNamed:imgName];

    [_downBtn setTitle:downName forState:UIControlStateNormal];
    [_downBtn setImage:[UIImage imageNamed:imgDown] forState:UIControlStateNormal];
    [_downBtn setImage:[UIImage imageNamed:imgDownHigh] forState:UIControlStateHighlighted];
}

@end


