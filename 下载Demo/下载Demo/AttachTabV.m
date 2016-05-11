//
//  AttachTabV.m
//  YDH
//
//  Created by longpc on 14/12/31.
//  Copyright (c) 2014年 YDH_lpc. All rights reserved.
//

#import "AttachTabV.h"
#import "FileCell.h"

@interface AttachTabV ()<UITableViewDataSource,UITableViewDelegate,DownloadDelegate>

@end

@implementation AttachTabV{
    NSMutableArray *dataArray;
    
    UILabel *emptyLab; //暂无附件
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        fileManage.downloadDelegate = self;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


-(void)attachvWithArray:(NSMutableArray *)attachs resetFrame:(BOOL)frameFlag{

    dataArray = [NSMutableArray arrayWithArray:attachs];
    //获取已下载的列表
    if (fileManage.finishedList.count != 0) {
        for (int i = 0; i < dataArray.count; i++) {
            FileModel *file = dataArray[i];
            for (int j = 0; j< fileManage.finishedList.count; j++) {
                FileModel *finishFile = fileManage.finishedList[j];
                if ([file.downUrlString isEqual:finishFile.downUrlString]) {
                    [dataArray replaceObjectAtIndex:i withObject:finishFile];
                    break ;
                }
            }
        }
    }
    //获取正在下载的列表
    if (fileManage.downinglist.count != 0) {
        for (int i = 0; i < dataArray.count; i++) {
            FileModel *file = dataArray[i];
            for (int j = 0; j< fileManage.downinglist.count; j++) {
                FileModel *downingFile = fileManage.downinglist[j];
                if ([file.downUrlString isEqual:downingFile.downUrlString]) {
                    [dataArray replaceObjectAtIndex:i withObject:downingFile];
                    break ;
                }
            }
        }
    }
    
    [self reloadData];
    
    if (NO == frameFlag) {
        return;
    }
    //重新设置 tabV 的frame
    CGRect _oldFrame = self.frame;
    _oldFrame.size.height = self.contentSize.height;
    if (emptyLab) {
        emptyLab.hidden = YES;
        [emptyLab removeFromSuperview];
        emptyLab = nil;
    }
    self.frame = _oldFrame;
}


#pragma mark--
#pragma mark tabelView的datasource代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileCell *cell = (FileCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"reuseCell";
    FileCell *cell = (FileCell *)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    FileModel *attMd = [dataArray objectAtIndex:indexPath.row];
    [cell setFileInfo:attMd];
    
    cell.downBtn.tag = indexPath.row + 1000;
    [cell.downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //查看附件
    [fileManage showFile:dataArray[indexPath.row]];
}


#pragma mark -- cell button 点击事件 --
-(void)downBtnClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    FileModel *file = [dataArray objectAtIndex:btn.tag - 1000];

    if (file.downStatus == DownloadStatusDowning) {
        //取消下载、删除
        if ([fileManage deleteFile:file]) {
            file.downStatus = DownloadStatusNotDown;
            [self reloadData];
        }
    }else {
        //下载、重新下载
        [fileManage downWithModel:file];
    }
}


#pragma mark -- DownDelegate --
//开始下载
-(void)downLoadWillStart:(FileModel *)file{
    [self refreshCellUI:DownloadStatusDowning file:file progress:-1];
}

//正在下载
-(void)downLoadUpdateCell:(FileModel *)file progress:(CGFloat)progress{
    [self refreshCellUI:DownloadStatusDowning file:file progress:progress];
}

//下载完成
-(void)downLoadFinished:(NSData *)responseData file:(FileModel *)file{
    [self refreshCellUI:DownloadStatusDowned file:file progress:-1];
}

//联网失败
-(void)downLoadFailWithError:(NSError *)error file:(FileModel *)file{
    [self refreshCellUI:DownloadStatusNotDown file:file progress:-1];
}


/********刷新cell*******/
-(void)refreshCellUI:(DownloadStatus)downStatus file:(FileModel *)file progress:(CGFloat)progress{
    
    NSArray*cellArr = [self visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[FileCell class]])
        {
            FileCell *cell=(FileCell *)obj;
            if([cell.fileInfo.downUrlString isEqual:file.downUrlString])
            {
                if (progress < 0) {
                    //不是正在下载
                    [cell updateCell:downStatus];
                    cell.fileInfo.downStatus = file.downStatus;
                }else{
                    cell.progressView.progress = progress;
                }
            }
        }
    }
}


@end
