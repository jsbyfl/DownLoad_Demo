
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "LDProgressView.h"

@interface FileCell : UITableViewCell

@property (nonatomic,assign,readonly) CGFloat cellHeight;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,strong) LDProgressView *progressView;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorV;
@property (nonatomic,strong) FileModel *fileInfo;

-(void)updateCell:(DownloadStatus)downStatus;

@end
