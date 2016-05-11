
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>

#import "FileModel.h"
#import "FileHelper.h"
#import "DownloadDelegate.h"
#import "MKNetworkKit.h"

#define MAX_LINES   6

@interface FilesDownManage : NSObject<UIDocumentInteractionControllerDelegate>

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *access_token;

@property(nonatomic,weak)id<DownloadDelegate> downloadDelegate;//下载列表delegate
@property(nonatomic,weak)id<DownloadDelegate> vcDelegate;//推出页面delegate

@property(nonatomic,retain)NSString *basepath; //(用户名-文件夹名)暂不使用

@property(nonatomic,retain)NSMutableArray *finishedList;//已下载完成的文件列表（文件对象）
@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表
@property(nonatomic,retain)NSMutableArray *filelist; //正在下载+本地已下载（包括本地已下载的）暂不使用

@property(nonatomic,retain)FileModel *fileInfo;

@property (nonatomic,strong) UIDocumentInteractionController *documentIC;


//＊＊＊第一次＊＊＊初始化使用，设置缓存文件夹和已下载文件夹
+(FilesDownManage *) sharedFilesDownManage;
+(FilesDownManage *) sharedFilesDownManageWithBasepath:(NSString *)basepath;


-(void)downWithModel:(FileModel*)model; //下载附件(包含 对已下载或正在下载的文件 进行重新下载)
-(void)showFile:(FileModel *)file; //查看附件
-(BOOL)deleteFile:(FileModel *)fileDel; //删除附件（对该附件进行删除、重新下载、取消正在下载）
-(void)clearAllFinished; //清空所有已下载附件


-(void)clearAllRquests; //取消所有正在下载
-(void)loadFinishedFiles;//将本地已经下载完成的文件加载到已下载列表里


@end
