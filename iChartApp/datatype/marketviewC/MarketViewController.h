//
//  MarketViewController.h
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "data.h"
@interface MarketViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate,UIScrollViewDelegate>{
    
    UITableView *mytableview_productname;//左边的tableview,只用于展示产品的名字
    UITableView *mytableview_productdetail;//右边的用于展示字段
    NSString *string_yanse;//用老接收高亮或者黑暗
    NSString *string_color;//用来判断高亮或者黑暗
    UIScrollView *scrowview_cellsc;
    int count;//用于计算获取数据的次数
    GCDAsyncSocket *_socket;
    GCDAsyncSocket *socket1;
    UILabel *label_productname;//用于存放产品的名字
    // int biaozhiwei;
    // UILabel * label ;
}
@property(strong,nonatomic) NSString *stringhost;
@property(strong,nonatomic) NSString *stringport;
@property (nonatomic,assign)int signin;

@property(strong,nonatomic) NSString *sessionid;
@property(strong,nonatomic) NSString *captchas;


@property(assign,nonatomic) int biaozhiwei;//判断当前是什么类型的产品

@end
