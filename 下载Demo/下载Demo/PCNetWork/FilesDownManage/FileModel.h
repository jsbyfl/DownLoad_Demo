
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"

typedef enum : NSUInteger {
    DownloadStatusNotDown   = 0, //未下载
    DownloadStatusDowning   = 1, //正在下载
    DownloadStatusDowned    = 2  //已下载
} DownloadStatus;

//(1-商品 2-订单 3-通知 4-付款记录)
typedef enum : NSUInteger {
    AttachmentTypeProduct   = 1, //商品
    AttachmentTypeOrder     = 2, //订单
    AttachmentTypeNotice    = 3, //通知
    AttachmentTypePayRecord = 4  //付款记录
} AttachmentType;

@interface FileModel : NSObject

@property (nonatomic,copy) NSString *downUrlString;

@property (nonatomic,strong) MKNetworkOperation *request;
@property (nonatomic,assign) DownloadStatus downStatus;
@property (nonatomic,assign) AttachmentType attachType;

@property(nonatomic,retain)NSString *tempPath; //临时路径
@property(nonatomic,retain)NSString *targetPath; //存入本地的地址无效(每次启动沙盒路径会变)

-(id)initWithDic:(NSDictionary *)dic; //从plist文件读取
-(id)initWithDic:(NSDictionary *)dic attachType:(AttachmentType)attachType; //网络请求

@end

