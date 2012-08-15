//
//  FileSelectViewController.h
//  iChartApp
//
//  Created by vinech.SZK on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableview_file;
    int mark[10];
}

@end
