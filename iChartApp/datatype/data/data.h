//
//  data.h
//  zxSocket
//
//  Created by bin huang on 12-7-17.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface data : NSObject
@property (nonatomic,assign)int messagelength;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)int result;
@property (nonatomic,assign)int captchaslength;
@property (nonatomic,assign)int sessionidlength;
@property (nonatomic,assign)int totallength;
@property (nonatomic,retain)NSString * publisherIPandPort;
@property (nonatomic,retain)NSString * captchas;
@property (nonatomic,retain)NSString * sessionID;
@property (nonatomic,retain)NSString * ndicate;

@end
