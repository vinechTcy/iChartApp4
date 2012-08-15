//
//  ChartViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChartViewController.h"
@interface ChartViewController (){
    UIImageView * imageV;
    CGRect rect;
    NSString * popTitle;
    UIView * view3;
    UIView * view1;
}


@end

@implementation ChartViewController

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
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UISegmentedControl * segmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"<",@">", nil]];
    segmentC.frame = CGRectMake(260, 10,70,30);               
    segmentC.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentC.momentary = NO;    //设置在点击后是否恢复原样 
    segmentC.multipleTouchEnabled=NO;  //可触摸
    segmentC.tintColor = [UIColor grayColor];
    [segmentC addTarget:self action:@selector(mySegment:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentC];
    // self.navigationItem.rightBarButtonItem = segButton;   
    
    //    
    //    UIView * viewNga = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 160, 34)];
    //    viewNga.backgroundColor  = [UIColor clearColor];
    
    //    UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonSystemItemDone target:self action:@selector(ngaButton:)];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:segButton, nil];
    
    //    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(110,5, 50, 24);
    //    [button addTarget:self action:@selector(ngaButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [button setTitle:@"Set" forState:UIControlStateNormal];
    //    [viewNga addSubview:button];
    
    //self.navigationItem.titleView = viewNga;
    
    
    UIView * aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds ];
    aView.backgroundColor = [UIColor blackColor];
    self.view =aView;
    
    UILabel * label = [[UILabel   alloc] initWithFrame:CGRectMake(10, 5, 130, 40)];
    label.text = @"USD/JPY";
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    label.backgroundColor = [UIColor clearColor];
    [aView addSubview:label];
    
    UILabel * label1 = [[UILabel   alloc] initWithFrame:CGRectMake(10, 40,130, 30)];
    label1.text = @"Updated 12:30:01";
    label1.textAlignment = UITextAlignmentLeft;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label1.backgroundColor = [UIColor clearColor];
    [aView addSubview:label1];
    
    UILabel * label2 = [[UILabel   alloc] initWithFrame:CGRectMake(190, 5,100, 40)];
    label2.text = @"79781";
    label2.textAlignment = UITextAlignmentLeft;
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    label2.backgroundColor = [UIColor clearColor];
    [aView addSubview:label2];
    
    UILabel * label3 = [[UILabel   alloc] initWithFrame:CGRectMake(170, 40,160, 30)];
    label3.text = [NSString stringWithFormat:@"L:79.700      H:80.091"];
    label3.textAlignment = UITextAlignmentLeft;
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label3.backgroundColor = [UIColor clearColor];
    [aView addSubview:label3];
    
    UISegmentedControl * segmentTable = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"M1",@"D1",@"H1",@"5MIN",@"-",@"-",@"-",nil]];
    segmentTable.frame = CGRectMake(10, 70,300,40);               
    segmentTable.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentTable.momentary = NO;    //设置在点击后是否恢复原样 
    segmentTable.multipleTouchEnabled=NO;  //可触摸
    segmentTable.tintColor = [UIColor grayColor];
    [segmentTable addTarget:self action:@selector(segmentTable:) forControlEvents:UIControlEventValueChanged];
    [aView addSubview:segmentTable];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(250,70, 70, 40);
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(ngaButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Tools" forState:UIControlStateNormal];
    [aView addSubview:button];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10,115, 300, 220)];
    imageV.backgroundColor = [UIColor yellowColor];
    imageV.image = [UIImage imageNamed:@"DF.PNG"];
    imageV.userInteractionEnabled = YES;
    [aView addSubview:imageV];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [imageV addGestureRecognizer:pinch];
    rect = CGRectMake(0, 20, 320, 460);
    
    

    
    view3= [[UIView alloc] init ];
    view1 = [[UIView alloc] init ];
    
    view1.frame = CGRectMake(5, 80, 272, 1);
    view1.backgroundColor = [UIColor yellowColor];
    view3.frame = CGRectMake(150, 32, 1, 173);
    view3.backgroundColor = [UIColor yellowColor];
    
	// Do any additional setup after loading the view.
}


- (void)segmentTable:(UISegmentedControl *)sender
{
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
            
        }
            break;
        case 1:
        {
            
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
