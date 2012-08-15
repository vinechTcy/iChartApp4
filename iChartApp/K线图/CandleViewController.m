//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import "CandleViewController.h"
#import "ASIHTTPRequest.h"
#import "ResourceHelper.h"
#import "OptionViewController.h"
#import "Personaldetail.h"
@implementation CandleViewController

@synthesize candleChart;
@synthesize autoCompleteView;
@synthesize toolBar;
@synthesize candleChartFreqView;
@synthesize autoCompleteDelegate;
@synthesize timer;
@synthesize chartMode;
@synthesize tradeStatus;
@synthesize lastTime;
@synthesize status;
@synthesize req_freq;
@synthesize req_type;
@synthesize req_url;
@synthesize req_security_id;
@synthesize arrTitle;
@synthesize arrayEdit;
@synthesize stringhost;
@synthesize stringport;
@synthesize arrValue;
@synthesize hcandleChart;
@synthesize activity;

@synthesize Minute;//时间
@synthesize codeName;//产品名称
@synthesize userName;//密码
@synthesize passWord;//账号

@synthesize SELF_ACTIVITY_FRAME_X,SELF_ACTIVITY_FRAME_Y,SELF_ACTIVITY_FRAME_WIDTH,SELF_ACTIVITY_FRAME_HEIGHT,SELF_VIEW_FRAME_X,SELF_VIEW_FRAME_Y,SELF_VIEW_FRAME_WIDTH,SELF_VIEW_FRAME_HEIGHT,SELF_CANDLECHART_FRAME_X,SELF_CANDLECHART_FRAME_Y,SELF_CANDLECHART_FRAME_WIDTH,SELF_CANDLECHART_FRAME_HEIGHT ,BACKBUTTON_FRAME_Y,BACKBUTTON_FRAME_WIDTH,BACKBUTTON_FRAME_HEIGHT,BACKBUTTON_FRAME_X,VIEWHUB_FRAME_X,VIEWHUB_FRAME_Y,VIEWBACK_FRAME_X,VIEWBACK_FRAME_Y,VIEWHUB_FRAME_WIDTH,VIEWBACK_FRAME_WIDTH,VIEWHUB_FRAME_HEIGHT,VIEWBACK_FRAME_HEIGHT,LABELDATA_FRAME_X,LABELDATA_FRAME_Y,LABELDATA_FRAME_WIDTH,LABELDATA_FRAME_HEIGHT;
@synthesize viewBack ,viewHUB  ,imageBack ,backButton,biaoji,array_pro,string_color;
//nima lebi  de schou shabi 

- (void)backButtons
{
    [socket1 setDelegate:nil];
    [socket1 disconnect];
    
    [self.viewHUB setHidden:YES];
    [self.viewBack setHidden:YES];
    [self.activity stopAnimating];
    [self.imageBack setHidden:YES];
    [self.backButton setHidden:YES];
    
    self.viewHUB = nil;
    self.viewBack = nil;
    self.imageBack = nil;
    self.backButton = nil;
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *user_style=[NSUserDefaults standardUserDefaults];
    //    string_yanse = [[NSString alloc] init];
    //    string_color = [[NSString alloc] init];
    string_yanse=[user_style objectForKey:@"style"];
    
    NSLog(@"color ====   %@",string_color);
    
    if (![string_yanse isEqualToString:string_color]) 
    {
        NSLog(@"-------000990000000000000-=======");
        // [self viewDidLoad];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"zoulehaojicimamamamamammama");
    //判断是高亮状态还是黑暗状态
    if (string_yanse==nil) {
        string_yanse=@"dark";
        string_color=@"dark";
    }else {
        string_color=[NSString stringWithFormat:string_yanse];
    }
    
   
    backgroundViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    
    backgroundViews.backgroundColor = [UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f];
    if (upView == YES) {
        [backgroundViews setHidden:YES];
        
    }else {
        [backgroundViews setHidden:NO];
        
    }
    [self.view addSubview:backgroundViews];
    
    
    
    UISegmentedControl * segmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"<",@">", nil]];
    segmentC.frame = CGRectMake(260, 10,70,30);               
    segmentC.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentC.momentary = NO;    //设置在点击后是否恢复原样 
    segmentC.multipleTouchEnabled=NO;  //可触摸
    segmentC.tintColor = [UIColor grayColor];
    [segmentC addTarget:self action:@selector(mySegment:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentC];
    self.navigationItem.rightBarButtonItem =segButton;
        
    if (label.text!=nil) {
        [label removeFromSuperview];
    }
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 130, 40)];
    label.text = [array_pro objectAtIndex:self.biaoji];
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
    label.backgroundColor = [UIColor clearColor];
    [backgroundViews addSubview:label];
    
    Personaldetail *userproduct=[[Personaldetail alloc]init];
    userproduct = [Personaldetail findpersonaldetailwithproductname:label.text];
    
    //数据更新的时间
    if (label1.text!=nil) {
        [label1 removeFromSuperview];
    }
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 60+20,300, 30)];
    int time=[userproduct.time intValue];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYY-MM-dd HH:mm"];//时间格式，YYYY-MM-dd HH:mm:ss:SSSS
    NSString *dateString = [dateFormat stringFromDate:nd];  
    label1.text =[NSString stringWithFormat:@"最后更新时间: %@",dateString];
    label1.textAlignment = UITextAlignmentLeft;
    label1.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    [backgroundViews addSubview:label1];
    
    //开盘
    if (label2.text!=nil) {
        [label2 removeFromSuperview];
    }
    label2 = [[UILabel   alloc] initWithFrame:CGRectMake(120, 20,190, 40)];
    NSString * strings = [NSString stringWithFormat:@"%.5f",[userproduct.open floatValue]];
    
    
    NSString * str = @".";
    NSRange  range = [strings rangeOfString:str];
    NSString *str1 = [strings substringFromIndex:range.location+1];
    NSString *str2 = [[str1 substringFromIndex:2] substringToIndex:2];
    NSString *str3 = [strings stringByReplacingOccurrencesOfString:str2 withString:@"          "];
    label2.text = str3;     
    label2.textAlignment = UITextAlignmentRight;
    label2.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15];
    
    UILabel * label9 = [[UILabel alloc] initWithFrame:CGRectMake(128, 0, 52, 40)];
    label9.backgroundColor = [UIColor clearColor];
    label9.text = str2;
    label9.textColor = [UIColor whiteColor];
    label9.textAlignment = UITextAlignmentCenter;
    label9.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:45];
    [label2 addSubview:label9];
    [backgroundViews addSubview:label2];
    //最低，最高
    if (label3.text!=nil) {
        [label3 removeFromSuperview];
    }
    
    label3 = [[UILabel   alloc] initWithFrame:CGRectMake(10, 60,300, 30)];
    label3.text = [NSString stringWithFormat:@"High:%.5f             Low:%.5f",[userproduct.high floatValue] ,[userproduct.low floatValue]];
    label3.textAlignment = UITextAlignmentLeft;
    label3.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12];
    label3.backgroundColor = [UIColor clearColor];
    [backgroundViews addSubview:label3];
    
    label. backgroundColor=[UIColor clearColor];
    label1.backgroundColor=[UIColor clearColor];
    label2.backgroundColor=[UIColor clearColor];
    label3.backgroundColor=[UIColor clearColor];
    
    
    
    if ([string_color isEqualToString:@"dark"]) {
        self.view.backgroundColor=[UIColor blackColor];
        label.textColor=[UIColor whiteColor];
        label1.textColor=[UIColor whiteColor];
        label2.textColor=[UIColor whiteColor];
        label3.textColor=[UIColor whiteColor];
        
    }else {
        self.view.backgroundColor=[UIColor whiteColor];
        backgroundViews.backgroundColor = [UIColor whiteColor];
        label.textColor=[UIColor blackColor];
        label1.textColor=[UIColor blackColor];
        label2.textColor=[UIColor blackColor];
        label3.textColor=[UIColor blackColor];
    }
    
	
    
	//init vars
	self.chartMode  = 1; //1,图表模式
	self.tradeStatus= 1; //贸易地位？
    
    //**************到时候传值过来，就不用赋值了********************************************
	NSUserDefaults *user_chuanzhi=[NSUserDefaults standardUserDefaults];
    NSString *string_codename=[array_pro objectAtIndex:self.biaoji];
    self.userName = [user_chuanzhi objectForKey:@"remberusername"];//用户名
    self.passWord = [user_chuanzhi objectForKey:@"remberpassword"]; //密码
    
    if ([string_codename isEqualToString:@"现货白银"]) 
    {
        string_codename=@"XAGUS+D";
        
    }else if ([string_codename isEqualToString:@"白银T+D"]) {
        string_codename=@"AGT+D";
    }else if([string_codename isEqualToString:@"黄金T+D"]) {
        string_codename=@"AUT+D";
    }else if ([string_codename isEqualToString:@"美元指数"]) {
        string_codename = @"USD";
    }
    
    self.codeName = [NSString stringWithFormat:string_codename];  //产品名称
    NSLog(@"name=%@ *  password=%@  * codename=%@   ",[user_chuanzhi objectForKey:@"remberusername"],[user_chuanzhi objectForKey:@"remberpassword"],[array_pro objectAtIndex:self.biaoji]);
    //    self.codeName = @"USD";
    //    self.userName = @"test8899";
    //    self.passWord = @"123";
    self.Minute   = 30;    //时间周期
    
    //***********************************************************************************
    
    //selfview 大小
	[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
	//搜索bar
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width-250, 0, 250, 40)];
	[searchBar setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0]];
	searchBar.delegate = self;
	
    
	
    self.candleChart = [[Chart alloc] init];
    self.candleChart.delegate = self;
    
    self.hcandleChart = [[Chart alloc] init];
    self.hcandleChart.delegate = self;	
  
    
    
    [self initChart];//初始化数据
    [self getData];  //调用socket
    [self JUHUA];    //初始化菊花
    
}
#pragma mark-调节上下产品
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


#pragma mark - 菊花上的返回
-(void)back
{
    //定制读取数据
    [socket1 setDelegate:nil];
    [socket1 disconnect];
    
    
    //隐藏小菊花那些东西
    [self.viewHUB setHidden:YES];
    [self.viewBack setHidden:YES];
    [self.activity stopAnimating];
    [self.imageBack setHidden:YES];
    [self.backButton setHidden:YES];
    
    //清空指针
    self.viewHUB = nil;
    self.viewBack = nil;
    self.imageBack = nil;
    self.backButton = nil;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Hchart Delegate
- (void)HtimerTitle:(int)title
{
    NSLog(@"横屏 delegate");
    [self.viewHUB setHidden:YES];
    [self.viewBack setHidden:YES];
    [self.activity stopAnimating];
    [self.imageBack setHidden:YES];
    [self.backButton setHidden:YES];
    
    self.viewHUB = nil;
    self.viewBack = nil;
    self.imageBack = nil;
    self.backButton = nil;
    
    
    self.Minute = title;
    [self getData];
    [self JUHUA];
}

#pragma mark - chart Delegate
- (void)timerTitle:(int)title
{
    NSLog(@"title = %d",title);
    
    self.Minute = title;
    //    NSLog(@"竖屏 delegate");
    //    [self.viewHUB setHidden:YES];
    //    [self.viewBack setHidden:YES];
    //    [self.activity stopAnimating];
    //    [self.imageBack setHidden:YES];
    //    [self.backButton setHidden:YES];
    //    
    //    
    //    self.viewHUB = nil;
    //    self.viewBack = nil;
    //    self.imageBack = nil;
    //    self.backButton = nil;
    
    [self getData];
    [self JUHUA];
}

#pragma mark - 菊花那些东西初始化
- (void)JUHUA
{
    
    
    self.viewHUB = [[UIView alloc] initWithFrame:CGRectMake(self.VIEWHUB_FRAME_X, self.VIEWHUB_FRAME_Y, self.VIEWHUB_FRAME_WIDTH, self.VIEWHUB_FRAME_HEIGHT)];
    self.viewHUB.backgroundColor = [UIColor blackColor];
    self.viewHUB.alpha = 0.8;
    [self.navigationController.view addSubview:self.viewHUB];
    
    NSLog(@"with = %d, height = %d",self.VIEWHUB_FRAME_WIDTH,self.VIEWHUB_FRAME_HEIGHT);
    
    
    self.viewBack = [[UIView alloc] initWithFrame:CGRectMake(self.VIEWBACK_FRAME_X, self.VIEWBACK_FRAME_Y, self.VIEWBACK_FRAME_WIDTH, self.VIEWBACK_FRAME_HEIGHT)];
    self.viewBack.backgroundColor = [UIColor redColor];
    self.viewBack.layer.cornerRadius = 8;
    self.viewBack.alpha = 1;
    [self.viewHUB addSubview:self.viewBack];
    
    
    
    //    self.labelData = [[UILabel alloc] initWithFrame:CGRectMake(self.LABELDATA_FRAME_X, self.LABELDATA_FRAME_Y  , self.LABELDATA_FRAME_WIDTH, self.LABELDATA_FRAME_HEIGHT)];
    //    self.labelData.backgroundColor = [UIColor clearColor];
    //    self.labelData.textColor = [UIColor whiteColor];
    //    self.labelData.textAlignment = UITextAlignmentCenter;
    //    self.labelData.font = [UIFont systemFontOfSize:15];
    //    self.labelData.text = @"正在加载...";
    //    [self.viewBack addSubview:self.labelData];
    
    //无敌风火轮
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.SELF_ACTIVITY_FRAME_X, self.SELF_ACTIVITY_FRAME_Y, self.SELF_ACTIVITY_FRAME_WIDTH, self.SELF_ACTIVITY_FRAME_HEIGHT)];  
    [self.viewBack addSubview:activity];
    [self.activity startAnimating];
    
    
    
    self.imageBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.LABELDATA_FRAME_X, self.LABELDATA_FRAME_Y  , self.LABELDATA_FRAME_WIDTH, self.LABELDATA_FRAME_HEIGHT)];
    self.imageBack.userInteractionEnabled =YES;
    self.imageBack.image = [UIImage imageNamed:@"closebtn.png"];
    [self.viewBack addSubview:self.imageBack];
    
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor clearColor];
    self.backButton.frame = CGRectMake(self.BACKBUTTON_FRAME_X, self.BACKBUTTON_FRAME_Y, self.BACKBUTTON_FRAME_WIDTH, self.BACKBUTTON_FRAME_HEIGHT);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBack addSubview:self.backButton];
}

-(void)initChart{
	NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"20",@"20",@"20",@"20",nil];
	[self.candleChart setPadding:padding];
    [self.hcandleChart setPadding:padding];

	NSMutableArray *secs = [[NSMutableArray alloc] init];
	[secs addObject:@"4"];
	[secs addObject:@"0"];
	[secs addObject:@"4"];
	[self.candleChart addSections:3 withRatios:secs];
	[self.candleChart getSection:2].hidden = YES;
	[[[self.candleChart sections] objectAtIndex:0] addYAxis:0];
	[[[self.candleChart sections] objectAtIndex:1] addYAxis:0];
	[[[self.candleChart sections] objectAtIndex:2] addYAxis:0];
    
    [self.hcandleChart addSections:3 withRatios:secs];
	[self.hcandleChart getSection:2].hidden = YES;

    [[[self.hcandleChart sections] objectAtIndex:0] addYAxis:0];
	[[[self.hcandleChart sections] objectAtIndex:1] addYAxis:0];
	[[[self.hcandleChart sections] objectAtIndex:2] addYAxis:0];

	
	[self.candleChart getYAxis:2 withIndex:0].baseValueSticky = NO;
	[self.candleChart getYAxis:2 withIndex:0].symmetrical = NO;
	[self.candleChart getYAxis:0 withIndex:0].ext = 0.05;
    
    [self.hcandleChart getYAxis:2 withIndex:0].baseValueSticky = NO;
	[self.hcandleChart getYAxis:2 withIndex:0].symmetrical = NO;
	[self.hcandleChart getYAxis:0 withIndex:0].ext = 0.05;

	NSMutableArray *series = [[NSMutableArray alloc] init];
	NSMutableArray *secOne = [[NSMutableArray alloc] init];
	NSMutableArray *secTwo = [[NSMutableArray alloc] init];
	NSMutableArray *secThree = [[NSMutableArray alloc] init];
	
	//price
	NSMutableDictionary *serie = [[NSMutableDictionary alloc] init]; 
	NSMutableArray *data = [[NSMutableArray alloc] init];
	[serie setObject:@"price" forKey:@"name"];
	[serie setObject:@"Price" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"candle" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"0" forKey:@"section"];
	[serie setObject:@"249,222,170" forKey:@"color"];
	[serie setObject:@"249,222,170" forKey:@"negativeColor"];
	[serie setObject:@"249,222,170" forKey:@"selectedColor"];
	[serie setObject:@"249,222,170" forKey:@"negativeSelectedColor"];
	[serie setObject:@"176,52,52" forKey:@"labelColor"];
	[serie setObject:@"77,143,42" forKey:@"labelNegativeColor"];
	[series addObject:serie];
	[secOne addObject:serie];
	
	//MA10
	serie = [[NSMutableDictionary alloc] init]; 
	data = [[NSMutableArray alloc] init];
	[serie setObject:@"ma10" forKey:@"name"];
	[serie setObject:@"MA10" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"line" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"0" forKey:@"section"];
	[serie setObject:@"255,255,255" forKey:@"color"];
	[serie setObject:@"255,255,255" forKey:@"negativeColor"];
	[serie setObject:@"255,255,255" forKey:@"selectedColor"];
	[serie setObject:@"255,255,255" forKey:@"negativeSelectedColor"];
	[series addObject:serie];
	[secOne addObject:serie];
    
	//MA30
	serie = [[NSMutableDictionary alloc] init]; 
	data = [[NSMutableArray alloc] init];
	[serie setObject:@"ma30" forKey:@"name"];
	[serie setObject:@"MA30" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"line" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"0" forKey:@"section"];
	[serie setObject:@"250,232,115" forKey:@"color"];
	[serie setObject:@"250,232,115" forKey:@"negativeColor"];
	[serie setObject:@"250,232,115" forKey:@"selectedColor"];
	[serie setObject:@"250,232,115" forKey:@"negativeSelectedColor"];
	[series addObject:serie];
	[secOne addObject:serie];
	
	//MA60
	serie = [[NSMutableDictionary alloc] init]; 
	data = [[NSMutableArray alloc] init];
	[serie setObject:@"ma60" forKey:@"name"];
	[serie setObject:@"MA60" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"line" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"0" forKey:@"section"];
	[serie setObject:@"232,115,250" forKey:@"color"];
	[serie setObject:@"232,115,250" forKey:@"negativeColor"];
	[serie setObject:@"232,115,250" forKey:@"selectedColor"];
	[serie setObject:@"232,115,250" forKey:@"negativeSelectedColor"];
	[series addObject:serie];
	[secOne addObject:serie];
	
	
	//VOL
	serie = [[NSMutableDictionary alloc] init]; 
	data = [[NSMutableArray alloc] init];
	[serie setObject:@"vol" forKey:@"name"];
	[serie setObject:@"VOL" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"column" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"1" forKey:@"section"];
	[serie setObject:@"0" forKey:@"decimal"];
	[serie setObject:@"176,52,52" forKey:@"color"];
	[serie setObject:@"77,143,42" forKey:@"negativeColor"];
	[serie setObject:@"176,52,52" forKey:@"selectedColor"];
	[serie setObject:@"77,143,42" forKey:@"negativeSelectedColor"];
	[series addObject:serie];
	[secTwo addObject:serie];
	
	//candleChart init
    [self.candleChart setSeries:series];

	[[[self.candleChart sections] objectAtIndex:0] setSeries:secOne];
	[[[self.candleChart sections] objectAtIndex:1] setSeries:secTwo];
	[[[self.candleChart sections] objectAtIndex:2] setSeries:secThree];
	[[[self.candleChart sections] objectAtIndex:2] setPaging:YES];

    [self.hcandleChart setSeries:series];
	
	[[[self.hcandleChart sections] objectAtIndex:0] setSeries:secOne];
	[[[self.hcandleChart sections] objectAtIndex:1] setSeries:secTwo];
	[[[self.hcandleChart sections] objectAtIndex:2] setSeries:secThree];
	[[[self.hcandleChart sections] objectAtIndex:2] setPaging:YES];
	
	
	NSString *indicatorsString =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"indicators" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
	if(indicatorsString != nil){
		NSArray *indicators = [indicatorsString JSONValue];
		for(NSObject *indicator in indicators){
			if([indicator isKindOfClass:[NSArray class]]){
				NSMutableArray *arr = [[NSMutableArray alloc] init];
				for(NSDictionary *indic in indicator){
					NSMutableDictionary *serie = [[NSMutableDictionary alloc] init]; 
					[self setOptions:indic ForSerie:serie];
					[arr addObject:serie];
					[serie release];
				}
			    [self.candleChart addSerie:arr];
				[arr release];
			}else{
				NSDictionary *indic = (NSDictionary *)indicator;
				NSMutableDictionary *serie = [[NSMutableDictionary alloc] init]; 
				[self setOptions:indic ForSerie:serie];
				[self.candleChart addSerie:serie];
				[serie release];
			}
		}
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.candleChart addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}

-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie;{
	[serie setObject:[options objectForKey:@"name"] forKey:@"name"];
	[serie setObject:[options objectForKey:@"label"] forKey:@"label"];
	[serie setObject:[options objectForKey:@"type"] forKey:@"type"];
	[serie setObject:[options objectForKey:@"yAxis"] forKey:@"yAxis"];
	[serie setObject:[options objectForKey:@"section"] forKey:@"section"];
	[serie setObject:[options objectForKey:@"color"] forKey:@"color"];
	[serie setObject:[options objectForKey:@"negativeColor"] forKey:@"negativeColor"];
	[serie setObject:[options objectForKey:@"selectedColor"] forKey:@"selectedColor"];
	[serie setObject:[options objectForKey:@"negativeSelectedColor"] forKey:@"negativeSelectedColor"];
}

-(void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
	int index = btn.tag;
	
	if(index !=2){
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		CGRect rect = [self.candleChartFreqView frame];
		rect.origin.y =  self.view.frame.size.width - 40;
		[self.candleChartFreqView setFrame:rect];
		[UIView commitAnimations];
	}
	
	if(index>=21 && index<=28){
		for (UIView *subview in self.candleChartFreqView.subviews){
			UIButton *btn = (UIButton *)subview;
			btn.selected = NO;
		}
	}
	btn.selected = YES;
	
    switch (index) {
		case 1:{
			UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
			sel.selected = NO;
			self.chartMode  = 0;
			self.req_freq   = @"1m";
			self.req_type   = @"T";
			[self getData];
			break;
	    }
        case 2:{
			UIButton *sel = (UIButton *)[self.toolBar viewWithTag:1];
			sel.selected = NO;
			CGContextRef context = UIGraphicsGetCurrentContext();
			[UIView beginAnimations:nil context:context];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.3];
			CGRect rect = [self.candleChartFreqView frame];
			if(rect.origin.y == self.view.frame.size.width - 40){
				rect.origin.y =  self.view.frame.size.width - 160;
				[self.candleChartFreqView setFrame:rect];
			}else{
				rect.origin.y =  self.view.frame.size.width - 40;
				[self.candleChartFreqView setFrame:rect];
                btn.selected = NO;
                sel.selected = NO;
			}
			[UIView commitAnimations];
			break;
		}
        case 26:{
			UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
			sel.selected = NO;
			self.chartMode  = 1;
			self.req_freq   = @"d";
			self.req_type   = @"H";
			[self getData];
			break;
			break;
	    }
		case 27:{
			UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
			sel.selected = NO;
			self.chartMode  = 1;
			self.req_freq   = @"w";
			self.req_type   = @"H";
			[self getData];
			break;
			
	    }
		case 28:{
			UIButton *sel = (UIButton *)[self.toolBar viewWithTag:2];
			sel.selected = NO;
			self.chartMode  = 1;
			self.req_freq   = @"m";
			self.req_type   = @"H";
			[self getData];
			break;
			
	    }
		case 50:{
			UIGraphicsBeginImageContext(self.candleChart.bounds.size);    
			[self.candleChart.layer renderInContext:UIGraphicsGetCurrentContext()];    
			UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();    
			UIGraphicsEndImageContext();
			UIImageWriteToSavedPhotosAlbum(anImage,nil,nil,nil);
			break;
	    }
		default:
			break;
    }
    
}

- (void)doNotification:(NSNotification *)notification{
	UIButton *sel = (UIButton *)[self.toolBar viewWithTag:1];
	[self buttonPressed:sel];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	NSMutableArray *data = [self.autoCompleteDelegate.items mutableCopy];
    self.autoCompleteDelegate.selectedItems = data;
	[data release];
    self.autoCompleteView.hidden = NO;
	
	if([self isCodesExpired]){
	    [self getAutoCompleteData];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	CGRect rect = [self.autoCompleteView frame];
	rect.size.height = 300;
	[self.autoCompleteView setFrame:rect];
	[UIView commitAnimations];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[self.autoCompleteDelegate.selectedItems removeAllObjects];
    for(NSArray *item in self.autoCompleteDelegate.items){
	    if([[item objectAtIndex:0] hasPrefix:searchText]){
			[self.autoCompleteDelegate.selectedItems addObject:item];
		}
	}
	[self.autoCompleteView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	CGRect rect = [self.autoCompleteView frame];
	rect.size.height = 0;
	[self.autoCompleteView setFrame:rect];
	self.autoCompleteView.hidden = YES;
    if(![searchBar.text isEqualToString:@""]){
        self.req_security_id = [[[[[searchBar text] componentsSeparatedByString:@"（"] objectAtIndex:1] componentsSeparatedByString:@"）"] objectAtIndex:0];
        [self getData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    NSLog(@"CancelButtonClicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
    self.req_security_id = [[[[[searchBar text] componentsSeparatedByString:@"（"] objectAtIndex:1] componentsSeparatedByString:@"）"] objectAtIndex:0];
	[self getData];
}

-(BOOL)isCodesExpired{
	NSDate *date = [NSDate date];
	double now = [date timeIntervalSince1970];
	double last = now;
	NSString *autocompTime = (NSString *)[ResourceHelper  getUserDefaults:@"autocompTime"];
	if(autocompTime!=nil){
		last = [autocompTime doubleValue];
		if(now - last >3600*8){
		    return YES;
		}else{
		    return NO;
		}
    }else{
	    return YES;
	}
}

-(void)getAutoCompleteData{	
    NSString *securities =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"securities" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *data = [securities JSONValue];
    self.autoCompleteDelegate.items = data;
}

-(void)getData{
    if(chartMode == 0){
        [self.candleChart getSection:2].hidden = YES;
        [self.hcandleChart getSection:2].hidden = YES;
        
    }else{
        [self.candleChart getSection:2].hidden = NO;
        [self.hcandleChart getSection:2].hidden = NO;
    }
    //[self JUHUA];
    
    data1=[[data alloc]init];
    _data2=[[data2 alloc]init];
    count=2;
    
    socket1=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *err=nil;    
    if(![socket1 connectToHost:@"222.73.211.226" onPort:25010 error:&err]) 
    { 
        NSLog(@"连接出错");
    }else{
        NSLog(@"123123");
        [self addText:@"打开端口"];
    }
}

- (void)addText:(NSString *)str
{
    status.text = [status.text stringByAppendingFormat:@"%@\n",str];
}
#pragma mark - socket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    NSLog(@"sock.isConnected = %d",sock.isConnected);
    
    requestLength =[NSString stringWithFormat:@"104\\test8899\\123\\%@\\%d",self.codeName,self.Minute];
    NSLog(@"requestLength = %d",requestLength.length);
    
    request1=[NSString stringWithFormat:@"%d\\104\\test8899\\123\\%@\\%d",requestLength.length*2,self.codeName,self.Minute];
    requestData1 = [request1 dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    [socket1 writeData:requestData1 withTimeout:-1 tag:1];
    NSLog(@"request = %@",request1);
    
    
    [socket1 readDataWithTimeout:-1 tag:20];
    NSLog(@"**************");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"坑爹呢?登陆不上去!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"首页", nil];
    alertV.tag = 888;
    //  [alertV show];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{ 
    newMessage = [[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
    
    
    _data2.messagelength=[newMessage intValue];
    if (tag ==20) {
        [socket1 readDataToLength:_data2.messagelength withTimeout:-1 tag:21];
        return;
    }
    
    //   NSLog(@"length=========%d ~~~~~~~~~%d",_data2.messagelength,newMessage.length);
    
    NSLog(@"new = %@",newMessage);
    if (tag == 21) {
        
        if (sock==socket1)
        {                
            
            NSLog(@"第二次得到的数据");
            
            NSString *newMessage2 = newMessage;//[[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
            
            //              NSLog(@"第%d次的数据为\n==%@",count++,newMessage2);       
            
            NSArray   *arr = [newMessage2 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\\"]];
            datas =[[NSMutableArray alloc] init];
            NSMutableArray *newData =[[NSMutableArray alloc] init];
            
            NSMutableArray *allData =[[NSMutableArray alloc] init];
            NSMutableArray *category =[[NSMutableArray alloc] init];
            
            for (int i = 4; i<[arr count]; i++) 
            {
                NSString * lines = [arr objectAtIndex:i];
                [allData addObject:lines];
                if ([allData count]%6==0) {
                    
                    NSString * str = [allData objectAtIndex:0];
                    NSString * str1= [allData objectAtIndex:1];
                    NSString * str2= [allData objectAtIndex:2];
                    NSString * str3= [allData objectAtIndex:3];
                    NSString * str4= [allData objectAtIndex:4];
                    NSString * str5= [allData objectAtIndex:5];
                    
                    NSString * str6 = [NSString  stringWithFormat:@"%@,%@,%@,%@,%@,%@",str,str1,str2,str3,str4,str5];  
                    [newData addObject:str6];
                    [allData removeAllObjects];
                }
            }
            [newData addObject:@"Date,open,close,higt,low,volum"];
            
            // NSLog(@"%@ , %d",newData,[newData count]);
            for (int i = [newData count]-1; i>=0; i--) {
                NSString *line = [newData objectAtIndex:i];
                if([line isEqualToString:@""]){
                    //    continue;
                }
                NSArray   *arr = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                
                NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[[arr objectAtIndex:0] intValue]];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM-dd HH:mm"];
                NSString *dateString = [dateFormat stringFromDate:nd];   
                
                [category addObject:dateString];
                
                NSMutableArray *item =[[NSMutableArray alloc] init];
                //    //所有数据 DATE,OPEN,HIGH LOW CLOSE VOLUME ADJ CLOSE
                
                [item addObject:[arr objectAtIndex:1]];//open
                [item addObject:[arr objectAtIndex:2]];//CLOSE
                [item addObject:[arr objectAtIndex:3]];//HIGH
                [item addObject:[arr objectAtIndex:4]];//LOW
                [item addObject:[arr objectAtIndex:5]];//volume
                [datas addObject:item];
            }
            //   NSLog(@"data = %@,data = %d",datas,[datas count]);
            if (datas.count>5) {
                
                self.viewHUB.hidden = YES;
                self.viewBack.hidden = YES;
                [self.activity stopAnimating];
                self.imageBack.hidden =YES ;
                self.backButton.hidden =YES;
                
                self.viewHUB = nil;
                self.viewBack = nil;
                self.imageBack = nil;
                self.backButton = nil;
                [self.activity stopAnimating];//风火轮停止
                
            }
            if(datas.count==0){
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"服务器数据=0!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"首页", nil];
                alertV.tag = 1000;
                [alertV show];
                //                return;
            }
            
            if (chartMode == 0) {
                if([self.req_type isEqualToString:@"T"]){
                    if(self.timer != nil)
                        [self.timer invalidate];
                    [self.candleChart reset];
                    [self.hcandleChart reset];
                    
                    [self.candleChart clearData];
                    [self.hcandleChart clearData];
                    
                    [self.candleChart clearCategory];
                    [self.hcandleChart clearCategory];
                    
                    
                    if([self.req_freq hasSuffix:@"m"]){
                        self.req_type = @"L";
                    }
                }else{
                    
                    NSString *time = [category objectAtIndex:0];
                    
                    if([time isEqualToString:self.lastTime]){
                        
                        if([time hasSuffix:@"1500"]){
                            if(self.timer != nil)
                                [self.timer invalidate];
                        }
                        return;
                    }
                    if ([time hasSuffix:@"1130"] || [time hasSuffix:@"1500"]) {
                        if(self.tradeStatus == 1){
                            self.tradeStatus = 0;
                        }
                    }else{
                        self.tradeStatus = 1;
                    }
                }
            }else{
                if(self.timer != nil)
                    [self.timer invalidate];
                [self.candleChart reset];
                [self.candleChart clearData];
                [self.candleChart clearCategory];
                
                [self.hcandleChart reset];
                [self.hcandleChart clearData];
                [self.hcandleChart clearCategory];
            }
            
            self.lastTime = [category lastObject];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [self generateData:dic From:datas];
            [self setData:dic];
            NSLog(@"dic = %d",datas.count);
            
            
            if(chartMode == 0){
                [self setCategory:category];
            }else{
                NSMutableArray *cate = [[NSMutableArray alloc] init];
                for(int i=60;i<category.count;i++){
                    [cate addObject:[category objectAtIndex:i]];
                }
                [self setCategory:cate];
            }
            [self.candleChart setNeedsDisplay];
            [self.hcandleChart setNeedsDisplay];
        }
    }
}

-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data{
	if(self.chartMode == 1){
		//price 
		NSMutableArray *price = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			[price addObject: [data objectAtIndex:i]];
		}
		[dic setObject:price forKey:@"price"];
		[price release];
		
		//VOL
		NSMutableArray *vol = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",[[[data objectAtIndex:i] objectAtIndex:4] floatValue]/100]];
			[vol addObject:item];
			[item release];
		}
		[dic setObject:vol forKey:@"vol"];
		[vol release];
		
		//MA 10
		NSMutableArray *ma10 = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float val = 0;
		    for(int j=i;j>i-10;j--){
			    val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
			}
			val = val/10;
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",val]];
			[ma10 addObject:item];
			[item release];
		}
		[dic setObject:ma10 forKey:@"ma10"];
		[ma10 release];
		
		//MA 30
		NSMutableArray *ma30 = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float val = 0;
		    for(int j=i;j>i-30;j--){
			    val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
			}
			val = val/30;
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",val]];
			[ma30 addObject:item];
			[item release];
		}
		[dic setObject:ma30 forKey:@"ma30"];
		[ma30 release];
		
		//MA 60
		NSMutableArray *ma60 = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float val = 0;
		    for(int j=i;j>i-60;j--){
			    val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
			}
			val = val/60;
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",val]];
			[ma60 addObject:item];
			[item release];
		}
		[dic setObject:ma60 forKey:@"ma60"];
		[ma60 release];
        
		//RSI6
		NSMutableArray *rsi6 = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float incVal  = 0;
			float decVal = 0;
			float rs = 0;
		    for(int j=i;j>i-6;j--){
				float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
				if(interval >= 0){
				    incVal += interval;
				}else{
				    decVal -= interval;
				}
			}
			
			rs = incVal/decVal;
			float rsi =100-100/(1+rs);
			
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
			[rsi6 addObject:item];
			[item release];
			
		}
		[dic setObject:rsi6 forKey:@"rsi6"];
		[rsi6 release];
		
		//RSI12
		NSMutableArray *rsi12 = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float incVal  = 0;
			float decVal = 0;
			float rs = 0;
		    for(int j=i;j>i-12;j--){
				float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
				if(interval >= 0){
				    incVal += interval;
				}else{
				    decVal -= interval;
				}
			}
			
			rs = incVal/decVal;
			float rsi =100-100/(1+rs);
			
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
			[rsi12 addObject:item];
			[item release];
		}
		[dic setObject:rsi12 forKey:@"rsi12"];
		[rsi12 release];
		
		//WR
		NSMutableArray *wr = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float h  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
			float l = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
			float c = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
		    for(int j=i;j>i-10;j--){
				if([[[data objectAtIndex:j] objectAtIndex:2] floatValue] > h){
				    h = [[[data objectAtIndex:j] objectAtIndex:2] floatValue];
				}
                
				if([[[data objectAtIndex:j] objectAtIndex:3] floatValue] < l){
					l = [[[data objectAtIndex:j] objectAtIndex:3] floatValue];
				}
			}
			
			float val = (h-c)/(h-l)*100;
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",val]];
			[wr addObject:item];
			[item release];
		}
		[dic setObject:wr forKey:@"wr"];
		[wr release];
		
		//KDJ
		NSMutableArray *kdj_k = [[NSMutableArray alloc] init];
		NSMutableArray *kdj_d = [[NSMutableArray alloc] init];
		NSMutableArray *kdj_j = [[NSMutableArray alloc] init];
		float prev_k = 50;
		float prev_d = 50;
        float rsv = 0;
	    for(int i = 60;i < data.count;i++){
			float h  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
			float l = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
			float c = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
		    for(int j=i;j>i-10;j--){
				if([[[data objectAtIndex:j] objectAtIndex:2] floatValue] > h){
				    h = [[[data objectAtIndex:j] objectAtIndex:2] floatValue];
				}
				
				if([[[data objectAtIndex:j] objectAtIndex:3] floatValue] < l){
					l = [[[data objectAtIndex:j] objectAtIndex:3] floatValue];
				}
			}
            
            if(h!=l)
                rsv = (c-l)/(h-l)*100;
            float k = 2*prev_k/3+1*rsv/3;
			float d = 2*prev_d/3+1*k/3;
			float j = d+2*(d-k);
			
			prev_k = k;
			prev_d = d;
			
			NSMutableArray *itemK = [[NSMutableArray alloc] init];
			[itemK addObject:[@"" stringByAppendingFormat:@"%f",k]];
			[kdj_k addObject:itemK];
			[itemK release];
			NSMutableArray *itemD = [[NSMutableArray alloc] init];
			[itemD addObject:[@"" stringByAppendingFormat:@"%f",d]];
			[kdj_d addObject:itemD];
			[itemD release];
			NSMutableArray *itemJ = [[NSMutableArray alloc] init];
			[itemJ addObject:[@"" stringByAppendingFormat:@"%f",j]];
			[kdj_j addObject:itemJ];
			[itemJ release];
		}
		[dic setObject:kdj_k forKey:@"kdj_k"];
		[dic setObject:kdj_d forKey:@"kdj_d"];
		[dic setObject:kdj_j forKey:@"kdj_j"];
		[kdj_k release];
		[kdj_d release];
		[kdj_j release];
		
		//VR
		NSMutableArray *vr = [[NSMutableArray alloc] init];
	    for(int i = 60;i < data.count;i++){
			float inc = 0;
			float dec = 0;
			float eq  = 0;
		    for(int j=i;j>i-24;j--){
				float o = [[[data objectAtIndex:j] objectAtIndex:0] floatValue];
				float c = [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
                
				if(c > o){
				    inc += [[[data objectAtIndex:j] objectAtIndex:4] intValue];
				}else if(c < o){
				    dec += [[[data objectAtIndex:j] objectAtIndex:4] intValue];
				}else{
				    eq  += [[[data objectAtIndex:j] objectAtIndex:4] intValue];
				}
			}
			
			float val = (inc+1*eq/2)/(dec+1*eq/2);
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",val]];
			[vr addObject:item];
			[item release];
		}
		[dic setObject:vr forKey:@"vr"];
		[vr release];
        
	}else{
		//price 
		NSMutableArray *price = [[NSMutableArray alloc] init];
	    for(int i = 0;i < data.count;i++){
			[price addObject: [data objectAtIndex:i]];
		}
		[dic setObject:price forKey:@"price"];
		[price release];
		
		//VOL
		NSMutableArray *vol = [[NSMutableArray alloc] init];
	    for(int i = 0;i < data.count;i++){
			NSMutableArray *item = [[NSMutableArray alloc] init];
			[item addObject:[@"" stringByAppendingFormat:@"%f",[[[data objectAtIndex:i] objectAtIndex:4] floatValue]/100]];
			[vol addObject:item];
			[item release];
		}
		[dic setObject:vol forKey:@"vol"];
		[vol release];
		
	}
}

-(void)setData:(NSDictionary *)dic{
	[self.candleChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
	[self.candleChart appendToData:[dic objectForKey:@"vol"] forName:@"vol"];
	
	[self.candleChart appendToData:[dic objectForKey:@"ma10"] forName:@"ma10"];
	[self.candleChart appendToData:[dic objectForKey:@"ma30"] forName:@"ma30"];
	[self.candleChart appendToData:[dic objectForKey:@"ma60"] forName:@"ma60"];
	
	[self.candleChart appendToData:[dic objectForKey:@"rsi6"] forName:@"rsi6"];
	[self.candleChart appendToData:[dic objectForKey:@"rsi12"] forName:@"rsi12"];
	
	[self.candleChart appendToData:[dic objectForKey:@"wr"] forName:@"wr"];
	[self.candleChart appendToData:[dic objectForKey:@"vr"] forName:@"vr"];
	
	[self.candleChart appendToData:[dic objectForKey:@"kdj_k"] forName:@"kdj_k"];
	[self.candleChart appendToData:[dic objectForKey:@"kdj_d"] forName:@"kdj_d"];
	[self.candleChart appendToData:[dic objectForKey:@"kdj_j"] forName:@"kdj_j"];
	
	NSMutableDictionary *serie = [self.candleChart getSerie:@"price"];
	if(serie == nil)
		return;
	if(self.chartMode == 1){
		[serie setObject:@"candle" forKey:@"type"];
	}else{
		[serie setObject:@"line" forKey:@"type"];
	}
}

-(void)setCategory:(NSArray *)category{
	[self.candleChart appendToCategory:category forName:@"price"];
	[self.candleChart appendToCategory:category forName:@"line"];
	
}

- (void)requestFailed:(ASIHTTPRequest *)request{
	self.status.text = @"Error!";
}

#pragma mark - 横竖屏shouldAuto
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        NSLog(@"横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏横屏");
        
        self.view.frame =CGRectMake(0, 0,480, 320);
        
        self.viewHUB.frame = CGRectMake(0, 0, 480,320);
        
        self.activity.frame = CGRectMake(0, 0,45, 45);
        
        self.viewBack.frame = CGRectMake(195, 127.5, 90, 45);
        
        self.imageBack.frame = CGRectMake(47.5+10.5, 12.5,20, 20);
        
        self.backButton.frame = CGRectMake(45,0, 45, 45);
        
        self.hcandleChart.frame = CGRectMake(0,0,self.view.frame.size.width, 320-32-49);
        
        [self.view addSubview:self.hcandleChart];
        
        [self.candleChart  removeFromSuperview];
        
        self.SELF_VIEW_FRAME_X = self.view.frame.origin.x;
        self.SELF_VIEW_FRAME_Y = self.view.frame.origin.y;
        self.SELF_VIEW_FRAME_WIDTH = self.view.frame.size.width;
        self.SELF_VIEW_FRAME_HEIGHT= self.view.frame.size.height;
        
        self.SELF_CANDLECHART_FRAME_X = self.candleChart.frame.origin.x;
        self.SELF_CANDLECHART_FRAME_Y = self.candleChart.frame.origin.y;
        self.SELF_CANDLECHART_FRAME_WIDTH = self.candleChart.frame.size.width;
        self.SELF_CANDLECHART_FRAME_HEIGHT= self.candleChart.frame.size.height;
        
        self.VIEWHUB_FRAME_X = self.viewHUB.frame.origin.x;
        self.VIEWHUB_FRAME_Y = self.viewHUB.frame.origin.y;
        self.VIEWHUB_FRAME_WIDTH = 480;
        self.VIEWHUB_FRAME_HEIGHT = 320;
        
        self.SELF_ACTIVITY_FRAME_X = 0;
        self.SELF_ACTIVITY_FRAME_Y = 0;
        self.SELF_ACTIVITY_FRAME_WIDTH = 45;
        self.SELF_ACTIVITY_FRAME_HEIGHT = 45;
        
        self.VIEWBACK_FRAME_X = 195;
        self.VIEWBACK_FRAME_Y = 127.5;
        self.VIEWBACK_FRAME_WIDTH = 90;
        self.VIEWBACK_FRAME_HEIGHT =45;
        
        self.LABELDATA_FRAME_X = 47.5+10.5;;
        self.LABELDATA_FRAME_Y = 12.5;
        self.LABELDATA_FRAME_WIDTH = 20;
        self.LABELDATA_FRAME_HEIGHT =20; 
        
        self.BACKBUTTON_FRAME_X = 45;
        self.BACKBUTTON_FRAME_Y = 0;
        self.BACKBUTTON_FRAME_WIDTH = 45; 
        self.BACKBUTTON_FRAME_HEIGHT= 45;
        
        upView  =YES;
        [backgroundViews setHidden:YES];
        
    }
    else {
        
        upView =NO;
        backgroundViews.backgroundColor = [UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f];
        [backgroundViews setHidden:NO];
        
        NSLog(@"竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏竖屏");
        
        
        self.view.frame =CGRectMake(0, 0, 320,480);
        
        self.candleChart.frame             = CGRectMake(0, 130, self.view.frame.size.width, 240);
        
        self.activity.frame                = CGRectMake(0, 0,45, 45);
        
        self.viewHUB.frame                 = CGRectMake(0, 0, 320,480);
        
        self.viewBack.frame                = CGRectMake(115, 200, 90, 45);
        
        self.imageBack.frame               = CGRectMake(47.5+10.5, 12.5,20, 20);
        
        self.backButton.frame              = CGRectMake(45,0, 45, 45);
        
        [self.view addSubview:self.candleChart];
        
        [self.hcandleChart removeFromSuperview];
        
        
        self.SELF_VIEW_FRAME_X             = self.view.frame.origin.x;
        self.SELF_VIEW_FRAME_Y             = self.view.frame.origin.y;
        self.SELF_VIEW_FRAME_WIDTH         = self.view.frame.size.width;
        self.SELF_VIEW_FRAME_HEIGHT        = self.view.frame.size.height;
        
        self.SELF_CANDLECHART_FRAME_X      = self.candleChart.frame.origin.x;
        self.SELF_CANDLECHART_FRAME_Y      = self.candleChart.frame.origin.y;
        self.SELF_CANDLECHART_FRAME_WIDTH  = self.candleChart.frame.size.width;
        self.SELF_CANDLECHART_FRAME_HEIGHT = self.candleChart.frame.size.height;
        
        self.VIEWHUB_FRAME_X               = self.viewHUB.frame.origin.x;
        self.VIEWHUB_FRAME_Y               = self.viewHUB.frame.origin.y;
        self.VIEWHUB_FRAME_WIDTH           =320;
        self.VIEWHUB_FRAME_HEIGHT          =480;
        
        self.SELF_ACTIVITY_FRAME_X         = 0;
        self.SELF_ACTIVITY_FRAME_Y         = 0;
        self.SELF_ACTIVITY_FRAME_WIDTH     = 45;
        self.SELF_ACTIVITY_FRAME_HEIGHT    = 45;
        
        self.VIEWBACK_FRAME_X              = 115;
        self.VIEWBACK_FRAME_Y              = 200;
        self.VIEWBACK_FRAME_WIDTH          = 90;
        self.VIEWBACK_FRAME_HEIGHT         = 45;
        
        self.LABELDATA_FRAME_X             = 47.5+10.5;
        self.LABELDATA_FRAME_Y             = 12.5;
        self.LABELDATA_FRAME_WIDTH         = 20;
        self.LABELDATA_FRAME_HEIGHT        = 20; 
        
        self.BACKBUTTON_FRAME_X            = 45;
        self.BACKBUTTON_FRAME_Y            = 0;
        self.BACKBUTTON_FRAME_WIDTH        = 45; 
        self.BACKBUTTON_FRAME_HEIGHT       = 45;
        
    }
    
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
	[self.timer invalidate];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
	[candleChart release];
	[autoCompleteView release];
	[toolBar release];
	[candleChartFreqView release];
	[autoCompleteDelegate release];
	[req_security_id release];
	[timer release];
	[lastTime release];
	[status release];
	[req_freq release];
	[req_type release];
	[req_url release];
	[req_security_id release];
}
@end