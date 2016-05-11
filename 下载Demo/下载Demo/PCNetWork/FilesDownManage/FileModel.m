
//  Created by longpc on 15/1/4.
//  Copyright (c) 2015年 longpc. All rights reserved.
//

#import "FileModel.h"

@interface FileModel ()

@property (nonatomic,copy) NSString *attachment;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *modifyTime;

@property (nonatomic,copy) NSString *attachmentId;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *size;

@end

@implementation FileModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _attachment = [NSString stringWithFormat:@"%@",dic[@"attachment"]];
        _createTime = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
        _modifyTime = [NSString stringWithFormat:@"%@",dic[@"modifyTime"]];
        
        _attachmentId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        _remark = [NSString stringWithFormat:@"%@",dic[@"remark"]];
        _fileName = [NSString stringWithFormat:@"%@",dic[@"fileName"]];
        _size = [NSString stringWithFormat:@"%@",dic[@"size"]];
        
        _tempPath = [FileHelper getTargetFilePath:_attachment];
        _targetPath = [FileHelper getTargetFilePath:_attachment];

        //从plist文件读取
        if (dic[@"attachType"]) {
            _attachType = [dic[@"attachType"] integerValue];
        }else{
            _attachType = 1;
        }
        if (dic[@"downStatus"]) {
            _downStatus = [dic[@"downStatus"] integerValue];
        }
    }
    return self;
}

-(id)initWithDic:(NSDictionary *)dic attachType:(AttachmentType)attachType{
    self = [super init];
    if (self) {
        _attachment = [NSString stringWithFormat:@"%@",dic[@"attachment"]];
        _createTime = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
        _modifyTime = [NSString stringWithFormat:@"%@",dic[@"modifyTime"]];
        
        _attachmentId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        _remark = [NSString stringWithFormat:@"%@",dic[@"remark"]];
        _fileName = [NSString stringWithFormat:@"%@",dic[@"fileName"]];
        _size = [NSString stringWithFormat:@"%@",dic[@"size"]];
        
        _attachType = attachType;
        _tempPath = [FileHelper getTargetFilePath:_attachment];
        _targetPath = [FileHelper getTargetFilePath:_attachment];
    }
    return self;
}

@end
