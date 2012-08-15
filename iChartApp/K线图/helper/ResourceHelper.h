//
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResourceHelper : NSObject {

}

+(UIImage *) loadImageByTheme:(NSString *) name;
+(UIImage *) loadImage:(NSString *) name;

+(NSObject *) getUserDefaults:(NSString *) name;
+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key;

@end
