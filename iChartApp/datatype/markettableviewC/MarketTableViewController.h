//
//  MarketTableViewController.h
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "data.h"

@interface MarketTableViewController : UIViewController<GCDAsyncSocketDelegate>
@property (nonatomic,assign)int Aa;
@property(strong)  GCDAsyncSocket *socket;
@property(nonatomic,assign) int biaoji;
@property(strong,nonatomic) NSString *stringhost;
@property(strong,nonatomic) NSString *stringport;
@property(strong,nonatomic) NSString *stringproductname;
@property(strong,nonatomic)NSMutableArray *array_pro;


@end
