//
//  NewsAnalysisViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//sssiis

#import "NewsAnalysisViewController.h"
#import "StoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kWBSDKDemoAppKey @"2131365630"
#define kWBSDKDemoAppSecret @"9ccde1899c528308145342904dfb7b18"
@interface NewsAnalysisViewController (){
    NSString *string;
    NSString *style;
    UITextView * textView;
    UILabel * UserNameLabel;
    UIButton * searchDateButton;
    UILabel * label;
    UIButton *button_logo;
}
@end

@implementation NewsAnalysisViewController
@synthesize myTableView,stringtext,dictionary_weibo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    string = [user objectForKey:@"style"];
    NSLog(@"viewvillappear..string ==================== %@",string);
    if ([style isEqualToString:string]==NO) {
        NSLog(@"执行了viewdiload");
        [self viewDidLoad];
    }if ([engine isLoggedIn]) {
        NSLog(@"hahhahhahhhhahahah");
    }else {
        NSLog(@"w cao");
        NSLog(@"===%@",engine.accessToken);
        // [engine logIn];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (string==nil) {
        string=@"dark";
        style=@"dark";
    }
    else 
    {
        style=[NSString stringWithFormat:string];   
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title=nil;
    //searchbar and 选择时间
    view_header=[[UIView alloc]initWithFrame:CGRectMake(170, 3, 140, 40)];
    view_header.backgroundColor=[UIColor clearColor];
    
    UIButton *button_searchword=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 35, 30)];
    button_searchword.backgroundColor=[UIColor blackColor];
    [button_searchword addTarget:self action:@selector(searchword) forControlEvents:UIControlEventTouchUpInside];
    [view_header addSubview:button_searchword];
    
    UIButton *button_searchtime=[[UIButton alloc]initWithFrame:CGRectMake(80, 0, 35, 30)];
    button_searchtime.backgroundColor=[UIColor blackColor];
    [button_searchtime addTarget:self action:@selector(searchtime) forControlEvents:UIControlEventTouchUpInside];
    [view_header addSubview:button_searchtime];
    
    UIBarButtonItem *buttonitem=[[UIBarButtonItem alloc]initWithCustomView:view_header];
    self.navigationItem.rightBarButtonItem=buttonitem;
    
    
    
    UIView * aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = aView;
    
    button_logo=[[UIButton alloc]initWithFrame:CGRectMake(0, 2, 125, 30)];
    button_logo.multipleTouchEnabled=NO;//不可触摸
    button_logo.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navilogo.png"]];
    //  button_logo.backgroundColor=[UIColor yellowColor];
    UIBarButtonItem *buttonleft=[[UIBarButtonItem alloc]initWithCustomView:button_logo];
    self.navigationItem.leftBarButtonItem=buttonleft;
    
    
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,460-44-49-100) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    //    self.myTableView.rowHeight = 80;
    
    //    UIButton *button_jiazai=[[UIButton alloc]initWithFrame:CGRectMake(50, 460-44-49-50, 130, 40)];
    //    [self.view addSubview:button_jiazai];
    //    button_jiazai.backgroundColor=[UIColor blueColor];
    //    [button_jiazai addTarget:self action:@selector(jiazai) forControlEvents:UIControlEventTouchUpInside];
    if (_refreshHeaderView == nil) 
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.view.frame.size.width, myTableView.bounds.size.height)];
        
		view.delegate = self;
		[myTableView addSubview:view];
        
        
        
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //_refreshLowView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, myTableView.bounds.size.height+0.0f, self.view.frame.size.width, myTableView.bounds.size.height)];
    //[myTableView addSubview:_refreshLowView];
    
    
    
    if ([style isEqualToString:@"dark"]) {
        aView.backgroundColor = [UIColor blackColor];
        
        
    }else {
        aView.backgroundColor = [UIColor whiteColor];
        
    }
    
    [aView addSubview:self.myTableView];
    engine=[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    engine.delegate=self;
    NSLog(@"accesstoken===========%@",engine.accessToken);
    
    [self performSelector:@selector(loaddata)];
	// Do any additional setup after loading the view.
}
#pragma mark-加载
-(void)jiazai{
    NSLog(@"正在加载");
}
#pragma mark-请求新郎微波的数据
-(void)loaddata{
    
    dataArr = [[NSMutableArray alloc] init];
    
    //statuses/user_timeline.json   请求我的微博数据
    //statuses/home_timeline.json   请求全部微博数据
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString *uid=@"2667934680";
    NSString *screen_name=@"久誉贵金属";
    NSString *count=@"20";
    NSString *trim_user=@"1";
    [dic setValue:engine.accessToken forKey:@"access_token"];
    [dic setValue:screen_name forKey:@"screen_name"];
    [dic setValue:count forKey:@"count"];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:trim_user forKey:@"trim_user"];
    
    //    [engine loadRequestWithMethodName:@"statuses/home_timeline.json" 
    //                           httpMethod:@"GET" params:dic 
    //                         postDataType:kWBRequestPostDataTypeNone 
    //                     httpHeaderFields:nil];
    [engine loadRequestWithMethodName:@"statuses/user_timeline.json" 
                           httpMethod:@"GET" params:dic 
                         postDataType:kWBRequestPostDataTypeNone 
                     httpHeaderFields:nil];
    
}
#pragma mark-接收数据的方法 wbengine的代理方法
-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    NSLog(@"==%@",result);
    //  NSLog(@"++%@,%@,requestDidSucceedWithResult = %@",self,self.view.subviews,result);
    
    if ([result isKindOfClass:[NSDictionary class]]) //模糊判断，MemberOfClass为精确判断
    {
        
        NSDictionary * dic = (NSDictionary *)result;
        [dataArr removeAllObjects];
        [dataArr addObjectsFromArray:[dic objectForKey:@"statuses"]];
        
        [self.myTableView reloadData];
    }
    
    
}
-(void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    NSLog(@"==？？？？？？？？requestDidFailWithError = %@",error);
}



#pragma mark-searchbar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
//    [aview_titleview removeFromSuperview];
//    NSLog(@"quxiaofangfa");
//}

-(void)searchword{
    NSLog(@"走了这个方法");
    //[view_header removeFromSuperview];
    view_header=nil;
    // [button_logo removeFromSuperview];
    //button_logo.hidden=YES;
    self.navigationItem.leftBarButtonItem=nil;
    aview_titleview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    aview_titleview.backgroundColor = [UIColor orangeColor];
    
    searchbar_word=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 260, 44)];
    [[searchbar_word.subviews objectAtIndex:0]removeFromSuperview];
    // searchbar_word.backgroundColor = [UIColor clearColor];
    
    searchbar_word.delegate=self;
    // searchbar_word.keyboardType=UIKeyboardTypePhonePad;//数字键盘
    searchbar_word.keyboardType=UIKeyboardTypeTwitter;//有搜索按钮
    searchbar_word.showsCancelButton=NO;
    [aview_titleview addSubview:searchbar_word];
    searchbar_word.placeholder=@"请输入：";
    UIButton *buttoncancell=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttoncancell.frame = CGRectMake(260, 8, 50, 30);
    [buttoncancell setTitle:@"cancel" forState:UIControlStateNormal];
    [aview_titleview addSubview:buttoncancell];
    [buttoncancell addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    //    searchbar_word.barStyle=UIBarStyleDefault;
    self.navigationItem.titleView=aview_titleview;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
    //[searchbar_word setShowsCancelButton:YES];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"执行搜索方法");
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"已经结束");
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchbar_word resignFirstResponder];
}
-(void)cancel{
    NSLog(@"yaoxi");
    aview_titleview=nil;
    //[aview_titleview removeFromSuperview];
}
-(void)searchtime
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"按时间查找" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"一天前",@"一周前",@"一月前",nil];
    actionSheet.frame = CGRectMake(0,300,320,160);
    
    [actionSheet showInView:self.view.window];
}
#pragma mark-tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([dataArr count]);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * stringcell
    = [NSString stringWithFormat:@"%d",indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringcell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:stringcell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.contentView.subviews) {
        
        [view removeFromSuperview];
    }
    
    UILabel *labletext;
    if ([dataArr count]!=0) {
        
        dictionary_weibo = [dataArr objectAtIndex:indexPath.row];//每条微博是一个字典
        stringtext= [NSString stringWithFormat:[dictionary_weibo objectForKey:@"text"]]; 
        NSLog(@"stringtext%@",stringtext);
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        CGSize constraintSize = CGSizeMake(240.0f, MAXFLOAT);
        CGSize labelSize = [stringtext sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        labletext=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, labelSize.height)];
        
        labletext.numberOfLines=0;
        labletext.backgroundColor=[UIColor clearColor];
        // cell.textLabel.font = [UIFont systemFontOfSize:13];
        labletext.text=stringtext;
        [cell addSubview:labletext];
        
        //[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
        //cell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        //[cell.textLabel setNumberOfLines:0];
        
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    if ([style isEqualToString:@"dark"]) {
        cell.backgroundColor = [UIColor blackColor];
        labletext.textColor = [UIColor whiteColor];
        //textView.textColor = [UIColor whiteColor];
        
        
    }else {
        cell.backgroundColor=[UIColor whiteColor];
        labletext.textColor = [UIColor blackColor];
        // textView.textColor = [UIColor blackColor];
        
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{CGSize labelSize;
    // NSString *stringtest=@"123";
    //创建一个新的CGSize来限制和计算text边框的大小
    
    if ([dataArr count]!=0) {
        dictionary_weibo = [dataArr objectAtIndex:indexPath.row];//每条微博是一个字典
        stringtext= [NSString stringWithFormat:[dictionary_weibo objectForKey:@"text"]];       // NSString *cellText = sts;
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        CGSize constraintSize = CGSizeMake(240.0f, MAXFLOAT);
        labelSize = [stringtext sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        NSLog(@"stringtext==%@",stringtext);
    }
    
    
    return labelSize.height + 20;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
//自己实现如果更新数据
- (void)reloadTableViewDataSource
{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}
//更新数据结束以后需要进行的操作
- (void)doneLoadingTableViewData
{
	
	//  model should call this when its done loading
	_reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
    [self loaddata];
	
}//在scrollView拖动的时候，调用的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    //HeaderView是自定义的一个View，它用自己的Controller的方法来控制
    //当滑动的时候HeaderView应该进行什么操作
    //这种处理问题的思想以后应该要借鉴
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
//在scrollView结束拖动的时候，调用的代理方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	//HeaderView是自定义的一个View，它用自己的Controller的方法来控制
    //当滑动结束的时候HeaderView应该进行什么操作
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

//如果拖动超过预定距离并且 没有在loading状态时由EGO调用的代理方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:5.0];
	
}
//返回当前加载状态
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	
	return _reloading; // should return if data source model is reloading
	
}
//功能是返回一个data，不过实际实现的是返回当前时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	//Creates and returns a new date set to the current date and time.
    //这个方法创建一个data里面包含当前的时间
	return [NSDate date]; // should return date data source was last changed
	
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320,80)];
//    
//    searchDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchDateButton.frame = CGRectMake(20,5,110,30);
//    [searchDateButton setTitle:@"时间检索" forState:UIControlStateNormal];
//    [searchDateButton addTarget:self action:@selector(searchDate) forControlEvents:UIControlEventTouchUpInside];
//    searchDateButton.layer.cornerRadius = 8;
//    
//    
//    
//    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchDate:)];
//    //    [searchDateLabel addGestureRecognizer:tap];
//    
//    UIImageView * downImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(95,10,10,10)];
//    downImageVIew.image = [UIImage imageNamed:@"toggle-arrow.png"];
//    downImageVIew.backgroundColor = [UIColor clearColor];
//    
//    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(150,45,170,30)];
//    
//    searchBar.showsCancelButton = NO;
//    searchBar.barStyle = UIBarStyleDefault;
//    searchBar.placeholder = @"内容检索";
//    searchBar.delegate = self;
//    searchBar.keyboardType = UIKeyboardTypeDefault;
//    searchBar.backgroundColor = [UIColor clearColor];
//    
//    for (UIView *subview in searchBar.subviews)   
//    {    
//        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])  
//        {    
//            [subview removeFromSuperview];    
//            break;  
//        }   
//    } 
//    
//    
//    
//    [searchView addSubview:searchBar];
//    [searchView addSubview:searchDateButton];
//    [searchDateButton addSubview:downImageVIew];
//    
//    if ([style isEqualToString:@"dark"]) {
//        searchView.backgroundColor = [UIColor blackColor];
//        searchDateButton.backgroundColor=[UIColor blackColor];
//        searchDateButton.titleLabel.textColor=[UIColor whiteColor];
//        
//        
//    }
//    else {
//        searchView.backgroundColor = [UIColor whiteColor];
//        searchDateButton.backgroundColor=[UIColor whiteColor];
//        searchDateButton.titleLabel.textColor=[UIColor blackColor];
//        
//    }
//    
//    return searchView;
//}
//newsssss
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryViewController * story= [[StoryViewController alloc] init];
    dictionary_weibo = [dataArr objectAtIndex:indexPath.row];//每条微博是一个字典
    stringtext= [NSString stringWithFormat:[dictionary_weibo objectForKey:@"text"]]; 
    //    NSString *string_url=[NSString stringWithFormat:[dictionary_weibo objectForKey:@"thumbnail_pic"]];
    //    NSLog(@"string_url===%@",string_url);
    //    //dictionary_weibo = [dataArr objectAtIndex:indexPath.row];//每条微博是一个字典
    //    if (string_url!=nil) {
    //        story.string_picture=string_url;
    //
    //    }
    story.string_text=self.stringtext;
    story.dicwb= dictionary_weibo;
    
    [self.navigationController pushViewController:story animated:YES];
    
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) { 
        self.myTableView.frame=CGRectMake(0, 0, 480, 320);
        //zuo 
    } 
    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) { 
        self.myTableView.frame=CGRectMake(0, 0, 480, 320);
        
        //you 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortrait) { 
        self.myTableView.frame=CGRectMake(0,0,320,460-44-49);
        
        //shang 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) { 
        self.myTableView.frame=CGRectMake(0,0,320,460-44-49);
        
        //xia 
    } 
    
    return YES;
}

@end
