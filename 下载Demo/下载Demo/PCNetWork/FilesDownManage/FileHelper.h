
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (NSString *)getUserDocument; //获取某用户名的附件文件夹
+ (NSString *)getTargetFilePath:(NSString *)fileName;
+ (NSString *)getFinishedPath; //获取当前用户已完成的plist路径


+(uint64_t)getFreeDiskspace;
+(uint64_t)getTotalDiskspace;
+(NSString *)getDiskSpaceInfo;


+ (BOOL)isExistFile:(NSString *)fileName; //检查文件名是否存在





////将字节转化成M单位，不附带M
//+(NSString *)transformToM:(NSString *)size;
////将不M的字符串转化成字节
//+(float)transformToBytes:(NSString *)size;
//将文件大小转化成M单位或者B单位
+(NSString *)getFileSizeString:(NSString *)size;
//经文件大小转化成不带单位ied数字
+(float)getFileSizeNumber:(NSString *)size;

//+(NSDate *)makeDate:(NSString *)birthday;
//+(NSString *)dateToString:(NSDate*)date;
//+(NSString *)getTempFolderPathWithBasepath:(NSString *)name;//得到临时文件存储文件夹的路径
//+(NSArray *)getTargetFloderPathWithBasepath:(NSString *)name subpatharr:(NSArray *)arr;


+(NSMutableArray *)getAllFinishFilesListWithPatharr:(NSArray *)patharr;
+ (NSString *)md5StringForData:(NSData*)data;
+ (NSString *)md5StringForString:(NSString*)str;

//传入文件总大小和当前大小，得到文件的下载进度
+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;


//文件支持
+ (NSArray *)filesSupports;

@end
