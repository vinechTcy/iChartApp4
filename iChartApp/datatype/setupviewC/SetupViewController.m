//
//  SetupViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "SetupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductSelectViewController.h"
#import "FileSelectViewController.h"
#define kWBSDKDemoAppKey @"2131365630"
#define kWBSDKDemoAppSecret @"9ccde1899c528308145342904dfb7b18"

@interface SetupViewController (){
    NSString * style;
    NSUserDefaults * user;
    NSString *styledangqian;
    NSString *stringl;
    NSString *style2;
    UIView * aView;
    CGRect rect;
    UIImage *imagehengshuping;
}

@end
@implementation SetupViewController
@synthesize myTableView = _myTableView,weiBoEngine;

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
    
    NSUserDefaults * user1 = [NSUserDefaults standardUserDefaults];
    stringl = [user1 objectForKey:@"style"];
    NSLog(@"viewvillappear..string ==================== %@",stringl);
    if (stringl==nil) {
        stringl=@"dark";
    }
    if ([styledangqian isEqualToString:stringl]==NO) {
        NSLog(@"执行了viewdiload");
        [self viewDidLoad];
    }
    
}

- (void)viewDidLoad
{count=0;
    
    [super viewDidLoad];
    
    //sinaweibo
    UIButton *button_logo=[[UIButton alloc]initWithFrame:CGRectMake(0, 2, 125, 30)];
    button_logo.multipleTouchEnabled=NO;//不可触摸
    button_logo.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navilogo.png"]];
    //  button_logo.backgroundColor=[UIColor yellowColor];
    UIBarButtonItem *buttonleft=[[UIBarButtonItem alloc]initWithCustomView:button_logo];
    self.navigationItem.leftBarButtonItem=buttonleft;
    
    
    
    
    WBEngine * engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    engine.delegate = self;
    self.weiBoEngine.delegate=self;
    engine.redirectURI = @"http://";
    engine.isUserExclusive = NO;
    self.weiBoEngine = engine;
    
    //黑白模式
    if (styledangqian==nil) {
        
        styledangqian=@"dark";
    }
    else {
        styledangqian=[NSString stringWithFormat:stringl];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    array1 = [NSArray arrayWithObjects:@"密码修改",@"界面风格",@"字体",@"产品",@"字段",@"是否推送",@"合作",@"微博",@"Log Out", nil];
    
    NSArray * array4 = [NSArray arrayWithObjects:@"旧密码",@"新密码",@"确认信密码", nil];//密码修改0
    NSArray * array5 = [NSArray arrayWithObjects:@"Bright",@"Dark", nil];//界面风格1
    NSArray * array6 = [NSArray arrayWithObjects:@"字体",nil];//字体2
    NSArray * array7 = [NSArray arrayWithObjects:@"产品",nil];//产品3
    NSArray * array8 = [NSArray arrayWithObjects:@"字段",nil];//字段4
    NSArray * array9 = [NSArray arrayWithObjects:@"分析报告",@"交易建议", nil];//推送5
    NSArray * array10 = [NSArray arrayWithObjects:@"商务合作",@"反馈", nil];//合作6
    NSArray * array11 = [NSArray arrayWithObjects:@"绑定微博", nil];//微博7
    NSArray * array12 = [NSArray arrayWithObjects:@"logout", nil];//登出8
    
    array2 = [NSMutableArray arrayWithObjects:array4,array5,array6,array7,array8,array9,array10,array11,array12,nil];
    
    aView = [[UIView alloc] init];
    
    aView.backgroundColor = [UIColor clearColor];
    self.view = aView;
    NSLog(@"22222");
    
    _myTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped ];
    
    _myTableView.delegate = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.dataSource = self;
    
    if ([styledangqian isEqualToString:@"dark"]) {
        _myTableView.backgroundColor = [UIColor blackColor];
        _myTableView.separatorColor=[UIColor whiteColor];
    }
    else {
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.separatorColor=[UIColor blackColor];
        
    }
    
    
    [aView addSubview:_myTableView];
    
    
    
    
    
    
    
    
	// Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array1 count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[array2 objectAtIndex:section] count];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section == 1) {
        NSLog(@"bright");
        style = @"bright";
        user = [NSUserDefaults standardUserDefaults];
        [user setObject:style forKey:@"style"];
        [user synchronize ];
        [self performSelector:@selector(viewWillAppear:)];
        
    }
    if (indexPath.row==1&&indexPath.section == 1) {
        NSLog(@"dark");
        style = @"dark";
        user = [NSUserDefaults standardUserDefaults];
        [user setObject:style forKey:@"style"];
        [user synchronize ];
        
        [self performSelector:@selector(viewWillAppear:)];
        
    }if (indexPath.section==4) {
        FileSelectViewController *aviewc=[[FileSelectViewController alloc]init];
        [self.navigationController pushViewController:aviewc animated:YES];
    }
    //6合作和反馈
    if (indexPath.section==6&&indexPath.row==1) {
        //[[UIApplicationsharedApplication]openURL:[NSURLURLWithString:@"http://itunesconnect.apple.com"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.appstore.com/"]];
        
    }
    //
    if (indexPath.section==7) {
        
        NSString *string_bangding=[user objectForKey:@"markstring"];
        
        if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])//判断微博是不是登录且没有推出，并且授权没有过期；如果微博登录过没有推出且授权没有过期执行语句体,切换根视图 
        {//https://api.weibo.com/2/friendships/create.json
            NSLog(@"已经成功登陆！");
            
            if (string_bangding==nil) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                NSString *uid=@"2667934680";
                NSString *screen_name=@"久誉贵金属";
                [dic setValue:self.weiBoEngine.accessToken forKey:@"access_token"];
                [dic setValue:screen_name forKey:@"screen_name"];
                [dic setValue:uid forKey:@"uid"];
                [weiBoEngine loadRequestWithMethodName:@"friendships/create.json" httpMethod:@"POST" params:dic postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
            }
            else {
                alertview_weibo=[[UIAlertView alloc]initWithTitle:@"已经绑定新浪微博" message:@"解除绑定么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertview_weibo show];
            }
            
            
        }
        else {
            NSLog(@"没有绑定微波！");
            [weiBoEngine logIn];
            
        }
        
    }
    
    if (indexPath.section==8) {
        [self performSelector:@selector(logout)];
    }
    if (indexPath.section==3) {
        ProductSelectViewController *aviewC=[[ProductSelectViewController alloc]init];
        
        [self.navigationController pushViewController:aviewC animated:NO];
    }
    
    
}
#pragma mark-sinaweibo
- (void)engineDidLogIn:(WBEngine *)engine{
    NSLog(@"登陆成功！");
    [engine sendWeiBoWithText:@"我正在使用ichart" image:nil];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString *uid=@"2667934680";
    NSString *screen_name=@"久誉贵金属";
    [dic setValue:self.weiBoEngine.accessToken forKey:@"access_token"];
    [dic setValue:screen_name forKey:@"screen_name"];
    [dic setValue:uid forKey:@"uid"];
    [weiBoEngine loadRequestWithMethodName:@"friendships/create.json" httpMethod:@"POST" params:dic postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    
    // UIAlertView *aview=[[UIAlertView alloc]initWithTitle:@"恭喜！" message:@"绑定成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    //    NSString *string=@"https://api.weibo.com/2/friendships/create.json";
    //    NSString *urlString = string;
    //    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    //    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    //    [requestForm setPostValue:@"2131365630" forKey:@"source"];
    //    [requestForm setPostValue:engine.accessToken forKey:@"access_token"];
    //    [requestForm setPostValue:@"2667934680" forKey:@"uid"];
    //    [requestForm setPostValue:@"玖誉贵金属" forKey:@"screen_name"];
    //    NSLog(@"response\n＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",[requestForm responseString]);
    //    
    //    [requestForm startSynchronous];
    // [aview show];
    
    
    
}
-(void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error{
    NSLog(@"登陆失败");
}

-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"==result%@",result);
        NSDictionary * dic = (NSDictionary *)result;
        NSMutableArray *dataArr=[[NSMutableArray alloc]init];
        [dataArr removeAllObjects];
        [dataArr addObject:[dic objectForKey:@"domain"]];
        NSLog(@"domain%@",[dataArr objectAtIndex:0]);
        NSString *string=[NSString stringWithFormat:[dataArr objectAtIndex:0]];
        NSLog(@"=================%@=",string);
        if ([string isEqualToString:@"everisegold"]) {
            NSLog(@"yaoxi ,chenggongle !");
            UIAlertView *aview=[[UIAlertView alloc]initWithTitle:@"恭喜！" message:@"绑定成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [aview show];
            //yijingbangding=YES;
        }
        NSUserDefaults *usermark=[NSUserDefaults standardUserDefaults];
        [usermark setObject:string forKey:@"markstring"];
        [usermark synchronize];
        ////
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        
    } 
    //
    
    if ([styledangqian isEqualToString:@"dark"]) {
        if (indexPath.section==8) {
            
            //            cell.backgroundColor = [UIColor blackColor];
            //            cell.textLabel.textColor = [UIColor redColor];
            cell.backgroundColor=[UIColor colorWithPatternImage:imagehengshuping];
            cell.textLabel.text=@"";
            NSLog(@"执行了此方法，改变了横竖屏幕");
            
        }
        else {
            cell.backgroundColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = [[array2 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            
            
        }
        
        
        
    }
    else {
        if (indexPath.section==8) {
            //           cell.backgroundColor = [UIColor whiteColor];
            //            cell.textLabel.textColor=[UIColor redColor];
            cell.backgroundColor=[UIColor colorWithPatternImage:imagehengshuping];
            cell.textLabel.text=@"";
            NSLog(@"执行了此方法，改变了横竖屏幕");
            
            
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.text = [[array2 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            
        }
        
        
    }
    
    
    // cell.textLabel.text = [[array2 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"cellcontentview%f=============%f",cell.contentView.frame.size.width,cell.contentView.frame.size.height);
    
    
    
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,280,30)];
    label.backgroundColor = [UIColor clearColor];
    if ([styledangqian isEqualToString:@"dark"]) {
        label.textColor = [UIColor whiteColor];
        view.backgroundColor = [UIColor clearColor];
        
    }
    else {
        label.textColor=[UIColor blackColor];
        view.backgroundColor = [UIColor whiteColor];
        
    }
    
    label.textAlignment = UITextAlignmentLeft;
    label.text = [array1 objectAtIndex:section];
    [view addSubview:label];
    return view;
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark-登出
-(void)logout{
    //    exit(0);
    //    if([[UIApplication sharedApplication] respondsToSelector:@selector(terminateWithSuccess)])
    //        [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
    //    [self performSelector:@selector(popi)];
    NSLog(@"nihaologout");
    LoginViewController *aviewc=[[LoginViewController alloc]init];
    [self presentModalViewController:aviewc animated:NO];
    exit(0);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"11111");
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) { 
        _myTableView.frame=CGRectMake(0, -5, 480, 320-44-49);
        NSLog(@"执行了改变tableviewfram");
        aView.frame=CGRectMake(0, 0, 480, 320);
        rect=CGRectMake(0, 0, 480, 320-44-55);
        imagehengshuping=[UIImage imageNamed:@"sign out1(1).png"];
        [_myTableView setContentOffset:CGPointMake(0, 550) animated:YES];
        NSLog(@"=========%f",_myTableView.contentOffset.y);
        
        // _myTableView.contentSize=CGSizeMake(480, 320*3);
        //zuo 
    } 
    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) { 
        _myTableView.frame=CGRectMake(0, -5, 480, 320-44-55);
        aView.frame=CGRectMake(0, 0, 480, 320);
        rect=CGRectMake(0, -5, 480, 320-44-55);
        imagehengshuping=[UIImage imageNamed:@"sign out1(1).png"];
        NSLog(@"=========%f",_myTableView.contentOffset.y);
        
        [_myTableView setContentOffset:CGPointMake(0, 550) animated:YES];
        //  NSLog(@"执行了改变tableviewfram");
        
        //_myTableView.contentSize=CGSizeMake(480, 320*3);
        //you 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortrait) { 
        count++;
        NSLog(@"count======%d",count);
        
        _myTableView.frame=CGRectMake(0, -5, 320, 480-44-55);
        aView.frame=CGRectMake(0, 0, 320, 480);
        rect=CGRectMake(0, 0, 320, 480-44-55);
        imagehengshuping=[UIImage imageNamed:@"sign out(7).png"];
        // [_myTableView setContentOffset:CGPointMake(0, 50) animated:YES];
        
        NSLog(@"=========%f",_myTableView.contentOffset.y);
        if (count>4) {
            NSLog(@"z执行了。。。。");
        }
        //shang 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) { 
        ;
        _myTableView.frame=CGRectMake(0, -5, 320, 480-44-55);
        aView.frame=CGRectMake(0, 0, 320, 480);
        // [_myTableView scrollsToTop];
        [_myTableView setContentOffset:CGPointMake(0, 50) animated:YES];
        //   NSLog(@"=========%f",_myTableView.contentOffset.y);
        
        imagehengshuping=[UIImage imageNamed:@"sign out(7).png"];
        
        
        //xia 
    } 
    return YES; }


@end
