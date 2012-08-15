//
//  StoryViewController.h
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//bb

#import <UIKit/UIKit.h>
#import "WBEngine.h"
@interface StoryViewController : UIViewController<UIActionSheetDelegate,WBEngineDelegate,UIAlertViewDelegate>{
    UIActionSheet *action;
    WBEngine *engine;
    UIAlertView *alertview;
}
@property(retain,nonatomic)NSString *string_text;
@property(retain,nonatomic)NSString *string_picture;

@property(strong,nonatomic)NSDictionary *dicwb;
@end
