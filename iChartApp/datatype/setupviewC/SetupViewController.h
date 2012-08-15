//
//  SetupViewController.h
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"

@interface SetupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate,WBEngineDelegate,UIAlertViewDelegate>
{
    NSArray * array1;//section
    NSMutableArray * array2;//row
    NSMutableArray * array3;//dataArray
    UIAlertView *alertview_weibo;
    int i;
    BOOL m;
    int count;
    BOOL mark;
    BOOL yijingbangding;
    NSString *markbangding;
}


@property(nonatomic,strong)UITableView * myTableView;
@property (nonatomic, retain) WBEngine *weiBoEngine;



@end
