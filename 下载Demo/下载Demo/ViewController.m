//
//  ViewController.m
//  下载Demo
//
//  Created by Bodyconn on 15/5/25.
//  Copyright (c) 2015年 LPC. All rights reserved.
//

#import "ViewController.h"
#import "AttachTabV.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *attachArrary;


@end

@implementation ViewController{
    AttachTabV *attachV;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    NSArray *arr = [NSArray arrayWithObjects:
                    @"http://219.239.26.20/download/53546556/76795884/2/dmg/232/4/1383696088040_516/QQ_V3.0.1.dmg",
                               @"http://219.239.26.11/download/46280417/68353447/3/dmg/105/192/1369883541097_192/KindleForMac._V383233429_.dmg",
                               @"http://free2.macx.cn:81/Tools/Office/UltraEdit-v4-0-0-7.dmg",
                               
                               @"http://124.254.47.46/download/53349786/76725509/1/exe/13/154/53349786_1/QQ2013SP4.exe",
                               @"http://dldir1.qq.com/qqfile/qq/QQ2013/QQ2013SP5/9050/QQ2013SP5.exe",
                               
                               @"http://dldir1.qq.com/qqfile/tm/TM2013Preview1.exe",
                               @"http://dldir1.qq.com/invc/tt/QQBrowserSetup.exe",
                               @"http://dldir1.qq.com/music/clntupate/QQMusic_Setup_100.exe",
                               @"http://dl_dir.qq.com/invc/qqpinyin/QQPinyin_Setup_4.6.2028.400.exe",nil];


    
    
    self.attachArrary = [NSMutableArray array];
    
    for (NSString *downString in arr) {
        FileModel *model = [FileModel new];
        model.downUrlString = downString;
        
        model.tempPath = [FileHelper getTargetFilePath:downString];
        model.targetPath = [FileHelper getTargetFilePath:downString];
        
        
        [self.attachArrary addObject:model];
    }
    
    
    
    attachV = [[AttachTabV alloc] initWithFrame:CGRectMake(0, 40, 320, 450)];
    [attachV attachvWithArray:self.attachArrary resetFrame:NO];
    [self.view addSubview:attachV];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
