//
//  DownloadDelegate.h


#import <Foundation/Foundation.h>
#import "FileModel.h"

@protocol DownloadDelegate <NSObject>

@optional

-(void)downLoadWillStart:(FileModel *)file; //开始联网
-(void)downLoadDidReceiveResponse:(NSURLResponse *)responseHeaders file:(FileModel *)file; //收到回复
-(void)downLoadUpdateCell:(FileModel *)file progress:(CGFloat)progress; //正在接收数据
-(void)downLoadFinished:(NSData *)responseData file:(FileModel *)file; //已经完成
-(void)downLoadFailWithError:(NSError *)error file:(FileModel *)file; //联网失败

-(void)pushViewC:(UIViewController *)viewC; //推出页面
-(void)allowNextRequest;//处理一个窗口内连续下载多个文件且重复下载的情况

@end
