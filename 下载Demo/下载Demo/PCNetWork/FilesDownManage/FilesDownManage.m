
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import "FilesDownManage.h"
//#import "FileShowViewC.h"       //显示附件

#define ATTACHMENT_STREAM_TYPE         @"application/octet-stream"

@interface FilesDownManage ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property(nonatomic,retain)NSMutableArray *targetPathArray;

@end

@implementation FilesDownManage{
    FileModel *_tempFileShow;
    BOOL isWanFlag;
}

static   FilesDownManage *sharedFilesDownManage = nil;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.count = 0;
        _filelist = [NSMutableArray array];
        _downinglist = [NSMutableArray array];
        _finishedList = [NSMutableArray array];
    }
    return self;
}

+(FilesDownManage *)sharedFilesDownManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFilesDownManage = [[self alloc] init];
    });
    return sharedFilesDownManage;
}

+(FilesDownManage *) sharedFilesDownManageWithBasepath:(NSString *)basepath{
    sharedFilesDownManage = [FilesDownManage sharedFilesDownManage];
    sharedFilesDownManage->isWanFlag = NO;

    NSString *tempPath = [FileHelper getUserDocument];
    if (![basepath isEqual:tempPath]) {
        basepath = tempPath;
    }
    if (![sharedFilesDownManage.basepath isEqualToString:basepath]) {
        [sharedFilesDownManage clearAllRquests];
        [sharedFilesDownManage loadFinishedFiles];
    }
    sharedFilesDownManage.basepath = basepath;
    DLog(@"path:%@\nfinishedList:%@",sharedFilesDownManage.basepath,sharedFilesDownManage.finishedList);
    return  sharedFilesDownManage;
}

/*
-(void)cleanLastInfo{
    for (FileModel *file in _downinglist) {
        if([file.request isExecuting])
            [file.request cancel];
    }
    [self saveFinishedFile];
    [_downinglist removeAllObjects];
    [_finishedList removeAllObjects];
    [_filelist removeAllObjects];
}
*/

-(void)clearAllRquests{
    for (FileModel *file in _downinglist) {
        
        //已经下载需要删除原有文件（因没有建立临时文件夹，正在下载的文件会有路径）
        if([FileHelper isExistFile:file.targetPath]) {
            NSError *error;
            if ([[NSFileManager defaultManager] removeItemAtPath:file.targetPath error:&error]!=YES) {
                DLog(@"删除文件出错:%@",[error localizedDescription]);
            }
        }
        ///////
        
        if([file.request isExecuting])
        [file.request cancel];
    }
    
    [_downinglist removeAllObjects];
    [_filelist removeAllObjects];
}

//保存已经下载的文件列表
-(void)saveFinishedFile{
    if (_finishedList == nil) {
        return;
    }
    
    NSMutableArray *finishedinfo = [NSMutableArray array];
    for (FileModel *file in _finishedList) {
//        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:file.attachment,@"attachment",
//                                 file.attachment,@"attachment",
//                                 file.attachmentId,@"id",
//                                 file.createTime,@"createTime",
//                                 file.modifyTime,@"modifyTime",
//                                 file.remark,@"remark",
//                                 file.fileName,@"fileName",
//                                 file.size,@"size",
//                                 file.remark,@"remark",
//                                 file.targetPath,@"targetPath",
//                                 [NSString stringWithFormat:@"%lu",(unsigned long)file.attachType],@"attachType",
//                                 [NSString stringWithFormat:@"%lu",(unsigned long)file.downStatus],@"downStatus",nil];
        
        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 file.downUrlString,@"downUrlString",
                                 file.targetPath,@"targetPath",
                                 [NSString stringWithFormat:@"%lu",(unsigned long)file.attachType],@"attachType",
                                 [NSString stringWithFormat:@"%lu",(unsigned long)file.downStatus],@"downStatus",nil];
        
        [finishedinfo addObject:filedic];
    }
    
    NSString *plistPath = [FileHelper getFinishedPath];
    DLog(@"%@",plistPath);
    if (![finishedinfo writeToFile:plistPath atomically:YES]) {
        DLog(@"write plist fail");
    }
}

//将本地已经下载完成的文件加载到已下载列表里
-(void)loadFinishedFiles{
    
    NSString *plistPath = [FileHelper getFinishedPath];

    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSMutableArray *finishArr = [NSMutableArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dic in finishArr) {
            FileModel *file = [[FileModel alloc]initWithDic:dic];
            [_finishedList addObject:file];
        }
    }
}


#pragma mark -- 附件相关 --
//下载附件
-(FileModel *)getFileData:(FileModel *)model{
    FileModel *file = [[FileModel alloc] init];
    
    file.downUrlString = model.downUrlString;

    file.attachType = model.attachType;
    file.tempPath = model.tempPath;
    file.targetPath = model.targetPath;
    file.request = model.request;
    
    return file;
}
-(void)downWithModel:(FileModel*)model{
    
    _fileInfo = [self getFileData:model];
    
     

    
    //是否正在下载
    for (FileModel *file in _downinglist) {
        if ([file.downUrlString isEqualToString:model.downUrlString]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经在下载列表中了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
    }
    
    //是否已经下载
    for (FileModel *file in _finishedList) {
        
        if ([file.downUrlString isEqualToString:model.downUrlString]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已下载，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            return ;
        }
    }
    
    //新的下载
    [self startLoad:model];
}

//查看附件
-(void)showFile:(FileModel *)file{
    if (file.downStatus == DownloadStatusDowned && self.vcDelegate && [self.vcDelegate respondsToSelector:@selector(pushViewC:)]) {
        _tempFileShow = file;
        
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"查看附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"在本APP中打开" otherButtonTitles:@"在其他APP中打开", nil];
        UIViewController *viewC = (UIViewController *)self.vcDelegate;
        [actSheet showInView:viewC.view];
        actSheet.tag = 1000;
        return ;
    }
}

//删除附件
-(BOOL)deleteFile:(FileModel *)fileDel{
    //将已下载数组中的对象删除
    NSInteger deleIndex = -1;
    BOOL isContains = NO; //是否包含
    
    for (FileModel *file in _finishedList) {
        if ([file.downUrlString isEqualToString:fileDel.downUrlString]) {
            deleIndex = [_finishedList indexOfObject:file];
            isContains = YES;
            break;
        }
    }
    if (isContains) {
        [_finishedList removeObjectAtIndex:deleIndex];
        [self saveFinishedFile]; //更新已下载的文件列表
    }
    isContains = NO;

    //已经下载需要删除原有文件（因没有建立临时文件夹，正在下载的文件会有路径）
    if([FileHelper isExistFile:fileDel.targetPath]) {
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:fileDel.targetPath error:&error]!=YES) {
            DLog(@"删除文件出错:%@",[error localizedDescription]);
            return NO;
        }
    }
    ///////
    {
        for(FileModel *file in _downinglist)
        {
            if([file.downUrlString isEqualToString:fileDel.downUrlString])
            {
                if ([file.request isExecuting]) {
                    [file.request cancel];
                }
                deleIndex = [_downinglist indexOfObject:file];
                isContains = YES;
                break;
            }
        }
        if (isContains) {
            [_downinglist removeObjectAtIndex:deleIndex];
        }
        isContains = NO;

        for (FileModel *file in _filelist) {
            if ([file.downUrlString isEqualToString:fileDel.downUrlString]) {
                deleIndex = [_filelist indexOfObject:file];
                isContains = YES;
                break;
            }
        }
        if (isContains) {
            [_filelist removeObjectAtIndex:deleIndex];
        }
    }
    ///////
    
    return YES;
}

//清空所有已下载附件
-(void)clearAllFinished{
    //1 _filelist
    //2 _finishedList plist
    //3 本地文件
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //删除已下载plist文件列表
    NSString *plistPath = [FileHelper getFinishedPath];
    DLog(@"%@",plistPath);
    if([FileHelper isExistFile:plistPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:plistPath error:&error] == NO) {
            DLog(@"删除plist文件出错:%@",[error localizedDescription]);
        }
    }

    //已经下载需要删除原有文件
    NSString *userDocument = [FileHelper getUserDocument];
    DLog(@"%@",userDocument);
    if ([fileManager isReadableFileAtPath:userDocument]) {
        NSError *error;
        if ([fileManager removeItemAtPath:userDocument error:&error] == NO) {
            DLog(@"删除用户附件目录出错:%@",[error localizedDescription]);
        }
    }
    
    [_finishedList removeAllObjects];
}


#pragma mark ----------
-(void)startLoad:(FileModel*)model{
    /*
     @"http://dldir1.qq.com/qqfile/qq/QQ2013/QQ2013SP5/9050/QQ2013SP5.exe", //57m
     
     @"http://dldir1.qq.com/qqfile/tm/TM2013Preview1.exe", //30m
     @"http://dldir1.qq.com/invc/tt/QQBrowserSetup.exe", //4,7
     @"http://dldir1.qq.com/music/clntupate/QQMusic_Setup_100.exe", //12m
     */
    
    /*
     付款记录附件  HTTP_DownloadPaymentAttachment
     通知附件     HTTP_NoticeFileDownload
     商品附件     HTTP_ProductAttachment
     综合 HTTP_Download_Attachment (1-商品 2-订单 3-通知 4-付款记录)
     */
    
    
    NSString *pathStr = [@"http://dldir1.qq.com/qqfile/qq/QQ2013/QQ2013SP5/9050/QQ2013SP5.exe" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    DLog(@"附件下载：%@",pathStr);
    

    MKNetworkEngine *engine = [[MKNetworkEngine alloc] init];
    MKNetworkOperation *downOp= [engine operationWithURLString:pathStr params:nil httpMethod:@"GET"];//继承自NSOperation
    
    
    model.request = downOp;

    [downOp addDownloadStream:[NSOutputStream outputStreamToFileAtPath:model.targetPath append:YES]];
    [downOp setFreezable:YES];
    
    __block FileModel *tempMd = model;
    
    //开始下载
    tempMd.downStatus = DownloadStatusDowning;
    [_filelist addObject:tempMd];
    [_downinglist addObject:tempMd];
    if (_downloadDelegate && [_downloadDelegate respondsToSelector:@selector(downLoadWillStart:)]) {
        [self.downloadDelegate downLoadWillStart:tempMd];
    }
    
    [downOp addDidReceiveResponseHandel:^(NSURLResponse *responseHeaders) {

        BOOL isCorrectType = NO;

        if ([responseHeaders isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responseHeaders;
            if (httpResponse.statusCode == 200) {
                NSDictionary *headerFields = [httpResponse allHeaderFields];
                
                if ([[headerFields objectForKey:@"Content-Type"] isEqual:ATTACHMENT_STREAM_TYPE]) {
                    isCorrectType = YES;
                }
            }
        }
        
        if (isCorrectType == YES) {
            if (_downloadDelegate && [_downloadDelegate respondsToSelector:@selector(downLoadDidReceiveResponse:file:)]) {
                [self.downloadDelegate downLoadDidReceiveResponse:responseHeaders file:tempMd];
            }
        }else{
            tempMd.downStatus = DownloadStatusNotDown;
            [_filelist removeObject:tempMd];
            [_downinglist removeObject:tempMd];
            
            if (_downloadDelegate && [_downloadDelegate respondsToSelector:@selector(downLoadFailWithError:file:)]) {
                [self.downloadDelegate downLoadFailWithError:nil file:tempMd];
            }

        }
    }];
    
    [downOp onDownloadProgressChanged:^(double progress) {
        if (_downloadDelegate && [_downloadDelegate respondsToSelector:@selector(downLoadUpdateCell:progress:)]) {
            [self.downloadDelegate downLoadUpdateCell:tempMd progress:progress];
        }
    }];
    
    
    //将正在下载的文件请求从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
    [downOp addCompletionHandler:^(MKNetworkOperation* completedRequest) {
        DLog(@"download file finished!");
        tempMd.downStatus = DownloadStatusDowned;
        
        [_filelist removeObject:tempMd];
        [_downinglist removeObject:tempMd];
        [_finishedList addObject:tempMd];

        //保存已下载的文件列表
        [self saveFinishedFile];

        if (_downloadDelegate && [_downloadDelegate respondsToSelector:@selector(downLoadFinished:file:)]) {
            [self.downloadDelegate downLoadFinished:[completedRequest responseData] file:tempMd];
        }
        
    }  errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        DLog(@"download file error: %@", err);
        
        tempMd.downStatus = DownloadStatusNotDown;
        [_filelist removeObject:tempMd];
        [_downinglist removeObject:tempMd];
        
        if (_downloadDelegate && [_downloadDelegate respondsToSelector:@selector(downLoadFailWithError:file:)]) {
            [self.downloadDelegate downLoadFailWithError:err file:tempMd];
        }
        
    }];
    
    [engine enqueueOperation:downOp];
}


#pragma mark -- UIAlertView Delegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 90) {
        if (buttonIndex == 1) {
            isWanFlag = YES;
            [self deleteFile:_fileInfo]; //先删除
            [self startLoad:_fileInfo]; //下载
        }
    }
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self deleteFile:_fileInfo]; //先删除
            [self startLoad:_fileInfo]; //下载
        }
    }
    
    
#if 0
    if(self.VCdelegate!=nil && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)])
    {
        [self.VCdelegate allowNextRequest];
    }
#endif
}


#pragma mark -- UIActionSheet Delegate --
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:
            {

            }
                break;
                
            case 1:
            {
                NSURL *URL=[NSURL fileURLWithPath:_tempFileShow.targetPath];
                if (URL) {

                    _documentIC = [UIDocumentInteractionController interactionControllerWithURL:URL];
                    [_documentIC setDelegate:self];
                    UIViewController *viewC = (UIViewController *)self.vcDelegate;
                    CGRect _tempRect = CGRectMake(50, 80, 100, 60);
                    [_documentIC presentOpenInMenuFromRect:_tempRect inView:viewC.view animated:YES];
                }
                
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark----
#pragma mark----  Document Interaction Controller Delegate Methods

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller{
    UIViewController *viewC = (UIViewController *)self.vcDelegate;
    return viewC;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller{
    UIViewController *viewC = (UIViewController *)self.vcDelegate;
    return viewC.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    UIViewController *viewC = (UIViewController *)self.vcDelegate;
    return viewC.view.frame;
}



@end


