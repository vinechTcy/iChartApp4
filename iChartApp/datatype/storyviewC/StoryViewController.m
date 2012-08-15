//
//  StoryViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StoryViewController.h"
#import "SetupViewController.h"
#import "AsyncImageView.h"

#define kWBSDKDemoAppKey @"2131365630"
#define kWBSDKDemoAppSecret @"9ccde1899c528308145342904dfb7b18"
@interface StoryViewController (){
    UIScrollView * scrollView;
    UILabel * contentLabel;
    NSString *string;
    NSString *style;
    
}

@end

@implementation StoryViewController
@synthesize string_text,dicwb,string_picture;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
//
-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    string = [user objectForKey:@"style"];
    NSLog(@"viewvillappear..string ==================== %@",string);
    if ([style isEqualToString:string]==NO) {
        NSLog(@"执行了viewdiload");
        [self viewDidLoad];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    engine=[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    engine.delegate=self;
    if (string==nil) {
        string =@"dark";
        style =@"dark";
    }
    else {
        style=[NSString stringWithFormat:string];
    }
    UIView *aview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view=aview;
    self.navigationItem.leftBarButtonItem.title = @"back";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //    self.navigationController.title = @"Story";
    
    UIView * viewtitle = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 200, 40)];
    viewtitle.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    label.text = @"Story";
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [viewtitle addSubview:label];
    self.navigationItem.titleView = viewtitle;
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(comeBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //    UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareMessage)];
    
    
    UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithTitle:@"share" style:UIBarButtonItemStyleDone target:self action:@selector(shareMessage)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    AsyncImageView *imageview_asy=[[AsyncImageView alloc]init];
    imageview_asy.urlString=self.string_picture;
    imageview_asy.center=CGPointMake(100, 20);
    //imageview_asy.backgroundColor=[UIColor redColor];
    NSLog(@"url====%@",[imageview_asy urlString]);
    UIImageView *imageview_ziji=[[UIImageView alloc]init];
    imageview_ziji.frame=CGRectMake(100, 0, 70, 40);
    imageview_ziji.image=[imageview_asy image];
    imageview_asy.backgroundColor=[UIColor blueColor];
    // [scrollView addSubview:imageview_ziji];
    //    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 60)];
    //    imageview.backgroundColor=[UIColor redColor];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,80,310,150)];
    contentLabel.numberOfLines = 20;
    contentLabel.text = self.string_text;
    contentLabel.backgroundColor=[UIColor clearColor];
    
    //来源
    UILabel * urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,260,310,150)];
    urlLabel.numberOfLines = 5;
    urlLabel.text = @"http://e.weibo.com/everisegold?ref=http%3A%2F%2Fweibo.com%2F2755998762%2Ffollow%3Fleftnav%3D1%26wvr%3D3.6";
    urlLabel.backgroundColor = [UIColor clearColor];
    //来源
    UILabel * sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,420,310,30)];
    sourceLabel.numberOfLines = 1;
    sourceLabel.text = @"source: 久誉贵金属官方微博";
    sourceLabel.backgroundColor = [UIColor clearColor];
    sourceLabel.textAlignment = UITextAlignmentLeft;
    //    [textView addSubview:sourceLabel];
    
    
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,460,310,30)];
    dateLabel.numberOfLines = 1;
    dateLabel.text = @"08-8月-2012 17:26:45";
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = UITextAlignmentLeft;
    //  [textView addSubview:dateLabel];
    // UIImageView  *imageview=[[UIImageView alloc]initWithImage:<#(UIImage *)#>];
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,460-44-49)];
    scrollView.contentSize = CGSizeMake(0,500);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [aview addSubview:scrollView];
    [scrollView addSubview:imageview_ziji];
    
    //[scrollView addSubview:titleLabel];
    [scrollView addSubview:contentLabel];
    [scrollView addSubview:urlLabel];
    [scrollView addSubview:sourceLabel];
    [scrollView addSubview:dateLabel];
    
    if ([style isEqualToString:@"dark"]) {
        aview.backgroundColor=[UIColor blackColor];
        //  titleLabel.textColor = [UIColor whiteColor];
        dateLabel.textColor = [UIColor whiteColor];
        sourceLabel.textColor = [UIColor whiteColor];
        urlLabel.textColor = [UIColor whiteColor];
        contentLabel.textColor = [UIColor whiteColor];
        label.textColor = [UIColor whiteColor];
        //  contentLabel.backgroundColor = [UIColor blackColor];
        
        
        
        
        
        
        
    }else {
        aview.backgroundColor=[UIColor whiteColor];
        //titleLabel.textColor = [UIColor blackColor];
        dateLabel.textColor = [UIColor blackColor];
        sourceLabel.textColor = [UIColor blackColor];
        urlLabel.textColor = [UIColor whiteColor];
        contentLabel.textColor = [UIColor blackColor];
        label.textColor = [UIColor blackColor];
        // contentLabel.backgroundColor = [UIColor whiteColor];
        
        
        
        
        
        
        
    }
    
	// Do any additional setup after loading the view.
}

-(void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareMessage
{
    action = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",nil];
    [action showInView:self.view.window];
}
#pragma mark-actionSheet delggate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"fenxiang");
        if ([engine isLoggedIn]) {
            [ engine sendWeiBoWithText:[NSString stringWithFormat:@"%@------来自久誉贵金属官方博客",self.string_text] image:nil];
        }else {
            alertview=[[UIAlertView alloc]initWithTitle:@"未绑定微博" message:@"是否绑定" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在绑定", nil];
            [alertview show];
        }
        
    }else {
        NSLog(@"quxiao");
    }
}
#pragma mark-enginedelegate
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    
    [self dismissModalViewControllerAnimated:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"分享成功！" 
													   message:nil 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
    
}
#pragma mark-uialertviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==alertview) {
        if (buttonIndex==1) {
            SetupViewController *aview=[[SetupViewController alloc]init];
            [self.navigationController pushViewController:aview animated:YES];
        }
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) { 
        scrollView.frame=CGRectMake(0, 0, 480, 320);
        contentLabel.frame=CGRectMake(5,50,470,200);
        //zuo 
    } 
    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) { 
        scrollView.frame=CGRectMake(0, 0, 480, 320);
        contentLabel.frame=CGRectMake(5,50,470,200);
        
        //you 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortrait) { 
        scrollView.frame=CGRectMake(0, 0, 320,460-44-49);
        contentLabel.frame=CGRectMake(5,50,310,200);
        
        //shang 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) { 
        scrollView.frame=CGRectMake(0, 0, 320,460-44-49);
        contentLabel.frame=CGRectMake(5,50,310,200);
        
        //xia 
    } 
    
    return YES;
}

@end
