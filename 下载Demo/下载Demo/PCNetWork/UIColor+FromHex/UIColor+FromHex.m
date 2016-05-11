//
//  UIColor+FromHex.m
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

#import "UIColor+FromHex.h"

@implementation UIColor (FromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    
    unsigned int hexint = 0;
    
    //convert the hex value into an unsigned integer
    //1. Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    //2. Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    //create a UIColor object by doing a bitwise ‘&’ operation to isolate the various color attributes and divide each by 255 to get the float value for the same.
    
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}


@end


