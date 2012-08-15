//
//  String.m
//
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import "NSString.h"


@implementation NSString(Helpers)

-(NSString *)toUTF8String{  
    CFStringRef nonAlphaNumValidChars = CFSTR("![DISCUZ_CODE_1]’()*+,-./:;=?@_~");          
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);          
    NSString *newStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8);  

    return newStr;          
}

@end
