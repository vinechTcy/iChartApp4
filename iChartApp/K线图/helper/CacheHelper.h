//
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheHelper : NSObject {

}

+ (void) setObject:(NSData *) data forKey:(NSString *) key withExpires:(int) expires;
+ (NSData *) get:(NSString *) key;
+ (void) clear;
+ (NSString *)getTempPath:(NSString*)key;
+ (BOOL)fileExists:(NSString *)filepath;
+ (BOOL)isExpired:(NSString *) key;

@end
