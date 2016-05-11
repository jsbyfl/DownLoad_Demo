//
//  UIColor+FromHex.h
//  UGift
//  from http://iosdevelopertips.com/conversion/how-to-create-a-uicolor-object-from-a-hex-value.html
//  //-----------------------------------------

// sample
// UIColor *color = [UIColor colorwithHexString:@"123ABC" alpha:.9];
// UIColor *color = [UIColor colorwithHexString:@"#123ABC" alpha:.9];
// UIColor *color = [UIColor colorwithHexString:@"0x123ABC" alpha:.9];

//-----------------------------------------
//  Created by Maveriks on 14-1-20.
//  Copyright (c) 2014年 Maveriks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
