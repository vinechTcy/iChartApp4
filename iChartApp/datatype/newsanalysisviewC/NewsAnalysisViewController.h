//
//  NewsAnalysisViewController.h
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "EGORefreshTableHeaderDelegate.h"
#import "EGORefreshTableHeaderView.h"
@interface NewsAnalysisViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,WBEngineDelegate,EGORefreshTableHeaderDelegate>{
    WBEngine * engine;
    NSMutableArray * dataArr;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableHeaderView *_refreshLowView;
    
	BOOL _reloading;
    UISearchBar *searchbar_word;//查询关键字
    UIView *view_header;//点击查询之前的
    UIView *aview_titleview;//点击了查询按钮之后的
    //  NSString *stringtext;
    
}
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSString *stringtext;
@property(nonatomic,strong)NSDictionary *dictionary_weibo;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
