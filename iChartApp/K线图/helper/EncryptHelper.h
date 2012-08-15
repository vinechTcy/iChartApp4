//
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EncryptHelper : NSObject {

}

+(NSString *) md5:(NSString *) str;
+(NSString *)fileMd5:(NSString *) path;

@end
