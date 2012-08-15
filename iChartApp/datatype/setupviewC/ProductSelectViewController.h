//
//  ProductSelectViewController.h
//  iChartApp
//
//  Created by bin huang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableview_product;
    NSArray * array_section;//section
    NSMutableArray * array_row;//row
    NSMutableArray * array3;//dataArray
    int mark[20][100];
    
}

@end
