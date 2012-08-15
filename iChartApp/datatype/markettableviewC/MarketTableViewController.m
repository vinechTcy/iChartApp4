//
//  MarketTableViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MarketTableViewController.h"
#import "MarketViewController.h"
#import "Personaldetail.h"
#import "Personaldetail.h"
#import "CandleViewController.h"
@interface MarketTableViewController (){
    UIImageView * imageV;
    CGRect rect;
    NSString * popTitle;
    NSString *string;
    NSString *style;
    UIView * view3;
    UIView * view1;
    UIView * aView;
    UILabel * label;
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    UILabel * label4;

    UIButton * button;
}
@end
@implementation MarketTableViewController
@synthesize Aa,socket,stringhost,stringport,stringproductname,biaoji,array_pro;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backbtn{
    
   // MarketViewController *aview=[[MarketViewController alloc]init];
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    string = [user objectForKey:@"style"];
    NSLog(@"viewvillappear..string ==================== %@",string);
    if ([style isEqualToString:string]==NO) {
        NSLog(@"执行了viewdiload");
        [self viewDidLoad];
    }
    
    for (int i=0; i<[array_pro count]; i++) {
        NSLog(@"==============pro===%@",[array_pro objectAtIndex:i]);
    }
    
}

- (void)viewDidLoad
{
    if (string==nil) {
        string =@"dark";
        style=@"dark";
    }else {
        style=[NSString stringWithFormat:string];
    }
    
    popTitle=@"返回";
    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:popTitle style:UIBarButtonItemStyleDone target:self action:@selector(backbtn)];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UISegmentedControl * segmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"<",@">", nil]];
    segmentC.frame = CGRectMake(260, 10,70,30);               
    segmentC.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentC.momentary = NO;    //设置在点击后是否恢复原样 
    segmentC.multipleTouchEnabled=NO;  //可触摸
    segmentC.tintColor = [UIColor grayColor];
    [segmentC addTarget:self action:@selector(mySegment:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentC];
    //self.navigationItem.rightBarButtonItem = segButton;   
    
    
    //    UIView * viewNga = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 160, 34)];
    //    viewNga.backgroundColor  = [UIColor clearColor];
    
    //  UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonSystemItemDone target:self action:@selector(ngaButton:)];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:segButton, nil];
    
    
    
     aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view =aView;
    
    //Personaldetail *userproduct=[[Personaldetail alloc]init];
   // userproduct = [Personaldetail findpersonaldetailwithproductname:cell.label1.text];

    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 130, 40)];
    label.text = [array_pro objectAtIndex:self.biaoji];
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    label.backgroundColor = [UIColor clearColor];
    [aView addSubview:label];
    
    Personaldetail *userproduct=[[Personaldetail alloc]init];
   userproduct = [Personaldetail findpersonaldetailwithproductname:label.text];

    //数据更新的时间
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 40,140, 30)];
    int time=[userproduct.time intValue];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYY-MM-dd HH:mm"];//时间格式，YYYY-MM-dd HH:mm:ss:SSSS
    NSString *dateString = [dateFormat stringFromDate:nd];  
   // NSLog(@"datastring%@",dateString);
    label1.text =dateString;
    label1.textAlignment = UITextAlignmentLeft;
    label1.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label1.backgroundColor = [UIColor clearColor];
    [aView addSubview:label1];
    
    //开盘
   label2 = [[UILabel   alloc] initWithFrame:CGRectMake(190, 5,100, 40)];
    label2.text = [userproduct.open substringToIndex:4];
    label2.textAlignment = UITextAlignmentLeft;
    label2.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    label2.backgroundColor = [UIColor clearColor];
    [aView addSubview:label2];
    
    //最高
    label3 = [[UILabel   alloc] initWithFrame:CGRectMake(160, 40,80, 30)];
    label3.text = [NSString stringWithFormat:@"H:%@",[userproduct.high substringToIndex:4]];
    label3.textAlignment = UITextAlignmentLeft;
    label3.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label3.backgroundColor = [UIColor clearColor];
    [aView addSubview:label3];
    
    //最低
    label4 = [[UILabel   alloc] initWithFrame:CGRectMake(240, 40,80, 30)];
    label4.text = [NSString stringWithFormat:@"L:%@",[userproduct.low substringToIndex:4]];
    label4.textAlignment = UITextAlignmentLeft;
    label3.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label4.backgroundColor = [UIColor clearColor];
    [aView addSubview:label4];

    
    UISegmentedControl * segmentTable = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"M1",@"D1",@"H1",@"5MIN",@"-",nil]];
    segmentTable.frame = CGRectMake(10, 70,200,40);               
    segmentTable.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentTable.momentary = NO;    //设置在点击后是否恢复原样 
    segmentTable.multipleTouchEnabled=NO;  //可触摸
    segmentTable.tintColor = [UIColor grayColor];
    [segmentTable addTarget:self action:@selector(segmentTable:) forControlEvents:UIControlEventValueChanged];
    [aView addSubview:segmentTable];
    
     button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(250,70, 70, 40);
    [button addTarget:self action:@selector(ngaButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Tools" forState:UIControlStateNormal];
    [aView addSubview:button];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10,115, self.view.frame.size.width, 220)];
    imageV.backgroundColor = [UIColor yellowColor];
    imageV.image = [UIImage imageNamed:@"DF.PNG"];
    imageV.userInteractionEnabled = YES;
    [aView addSubview:imageV];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [imageV addGestureRecognizer:pinch];
    rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    view3= [[UIView alloc] init ];
    view1 = [[UIView alloc] init ];
    
    view1.frame = CGRectMake(5, 80, 272, 1);
    view1.backgroundColor = [UIColor yellowColor];
    view3.frame = CGRectMake(150, 32, 1, 173);
    view3.backgroundColor = [UIColor yellowColor];
    
    if ([style isEqualToString:@"dark"]) {
        aView.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label1.textColor = [UIColor whiteColor];
        label2.textColor = [UIColor whiteColor];
        label3.textColor = [UIColor whiteColor];
        [button setBackgroundColor:[UIColor blackColor]];
        button.titleLabel.textColor=[UIColor whiteColor];





    }else {
        aView.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label1.textColor = [UIColor blackColor];
        label2.textColor = [UIColor blackColor];
        label3.textColor = [UIColor blackColor];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.titleLabel.textColor=[UIColor blackColor];





    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)segmentTable:(UISegmentedControl *)sender
{
    //WithFrame:CGRectMake(150,32, 1, 173)];
    
    
    //WithFrame:CGRectMake(5,80, 272, 1)];
    
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            imageV.image = [UIImage imageNamed:@"DF.PNG"];
            [imageV addSubview:view3];
            [imageV addSubview:view1];
            
            
        }
            break;
        case 1:
        {
            imageV.image = [UIImage imageNamed:@"MF.PNG"];
            
        }
            break;
        case 2:
        {
            imageV.image = [UIImage imageNamed:@"Mk.PNG"];
            
        }
            break;
        case 3:
        {
            imageV.image = [UIImage imageNamed:@"SH.PNG"];
            
        }
            break;
        case 4:
        {
            imageV.backgroundColor = [UIColor orangeColor];
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        default:
            break;
    }
}
- (void)mySegment:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            if (self.biaoji==0) {
                NSLog(@"当前是第一个");
            }
            else {
                NSLog(@"之前%d",self.biaoji);
                self.biaoji=self.biaoji-1;
                NSLog(@"之后%d",self.biaoji);
                [self viewDidLoad];

            }
            }
            
        
            break;
        case 1:
        {
            if ([array_pro count]==1) {
                NSLog(@"只有一个");
            }
    else {
        if (self.biaoji+1==[array_pro count]) {
            NSLog(@"当前已经是最后一个");
        }
        else {
            NSLog(@"之前%d",self.biaoji);
            self.biaoji=self.biaoji+1;
            NSLog(@"之后%d",self.biaoji);
            [self viewDidLoad];
            
        }
        

    }
          }
            break;
            
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) { 
        
        imageV.frame=CGRectMake(0, 0, 480, 320);
        
        
    } 
    
    if (interfaceOrientation==UIInterfaceOrientationPortrait||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) { 
        [self viewDidLoad];
        
        
        //shang 
    } 
    

    return YES;
}

@end
