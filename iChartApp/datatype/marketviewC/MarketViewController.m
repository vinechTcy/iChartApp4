//
//  MarketViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////////////////////////////////////////////////////////////////////////把25011改成25010sssss

#import "MarketViewController.h"
#import "MarketCell.h"
#import "MarketTableViewController.h"
#import "data2.h"
#import "LoginViewController.h"
#import "Personaldetail.h"
#import "CandleViewController.h"
@interface MarketViewController (){
    NSMutableArray * array_quanbuziduan;//所有的字段
    NSMutableArray *array_quanbuproductname;//所有的产品的名字
    UIScrollView *scrowviewheader;//字段名字的scrowview
    NSMutableArray *array_ziduan;//用来接收字段
    NSMutableArray *array_mark;//用来判断当前的字段
    NSMutableArray *array_product;//用来接收产品的名字
    NSMutableArray *array_chanpin;//用来判断当前的产品
    NSArray *array1000;//没有实际意义
    
    data2 *_data2;
    UIView *view_productnameheader;//左上
    UILabel * label_headerheader;//右上
    UILabel *lable_zhibiao;//右边的
    UILabel *label_nameheader;
}
@end

@implementation MarketViewController
@synthesize biaozhiwei,stringhost,sessionid,captchas,stringport,signin;
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
    //字段
    
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    array_ziduan=[user objectForKey:@"ziduan"];
    string_yanse=[user objectForKey:@"style"];
    
    //产品
    NSUserDefaults *user_forex=[NSUserDefaults standardUserDefaults];
    switch (biaozhiwei) {
        case 0:
            array_product=[user_forex objectForKey:@"forex"];
            break;
        case 1:
            array_product=[user_forex objectForKey:@"preciousmetal"];
            
            break;
        case 2:
            array_product=[user_forex objectForKey:@"exponent"];
            
            break;
            
        default:
            break;
    }
    NSUserDefaults *userhost=[NSUserDefaults standardUserDefaults];
    self.stringhost=[userhost objectForKey:@"host"];
    NSLog(@"host%@...",stringhost);
    
    NSUserDefaults *userport=[NSUserDefaults standardUserDefaults];
    self.stringport=[userport objectForKey:@"port"];
    self.sessionid=[userport objectForKey:@"id"];
    self.captchas=[userport objectForKey:@"captchas"];
    
    
    NSLog(@"waihui=======%@",array_product);
    if (array_chanpin!=array_product||array_mark!=array_ziduan||[string_yanse isEqualToString:string_color]==NO) 
    {
        [self viewDidLoad];
    }
    
    
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
//login

- (void)viewDidLoad
{     [super viewDidLoad];
    //登陆
    if (!signin) {
        signin=!signin;
        [self performSelector:@selector(login)];
    }
    
    //判断如果字段为空的话就等于全部的字段
    if (array_quanbuziduan==nil) {
        array_quanbuziduan = [[NSMutableArray alloc]initWithObjects:@"报价",@"最高",@"最低",@"涨跌幅",@"最后更新",nil];
    }    
    if ([array_ziduan count]==0) {
        array_mark=array_quanbuziduan;
        array_ziduan=array_quanbuziduan;
    }
    else {
        array_mark=array_ziduan;
    }
    //判断如果产品名字为空的话就等于全部的产品名字
    array_quanbuproductname = [[NSMutableArray alloc ] initWithObjects:@"美元指数",nil];
    if (array_product==nil) {
        array_product=array_quanbuproductname;
        array_chanpin=array_quanbuproductname;
    }else {
        array_chanpin=array_product;
    }
    //判断是高亮状态还是黑暗状态
    if (string_yanse==nil) {
        string_yanse=@"dark";
        string_color=@"dark";
    }else {
        string_color=[NSString stringWithFormat:string_yanse];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title=nil;
    
    
   // UISegmentedControl * segmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"<",@">", nil]];
    //segmentC.frame = CGRectMake(260, 10,70,30);               
  //  segmentC.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentC.momentary = NO;    //设置在点击后是否恢复原样 
//    segmentC.multipleTouchEnabled=NO;  //可触摸
//    segmentC.tintColor = [UIColor grayColor];
//    [segmentC addTarget:self action:@selector(mySegment:) forControlEvents:UIControlEventValueChanged];
//    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentC];
//    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:segButton, nil];
    
    
    UISegmentedControl * segmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"外汇",@"贵金属",@"指数", nil]];
    segmentC.frame = CGRectMake(160, 7, 160,30);               
    segmentC.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentC.momentary = NO;    //设置在点击后是否恢复原样 
    segmentC.multipleTouchEnabled=NO;  //可触摸
    segmentC.tintColor = [UIColor grayColor];
    [segmentC addTarget:self action:@selector(mySegments:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentC];
    self.navigationItem.rightBarButtonItem = segButton;
    UIButton *button_logo=[[UIButton alloc]initWithFrame:CGRectMake(0, 2, 125, 30)];
    button_logo.multipleTouchEnabled=NO;//不可触摸
    button_logo.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navilogo.png"]];
    //  button_logo.backgroundColor=[UIColor yellowColor];
    UIBarButtonItem *buttonleft=[[UIBarButtonItem alloc]initWithCustomView:button_logo];
    self.navigationItem.leftBarButtonItem=buttonleft;
    
    UIView *aview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-44-48-17)];
    self.view=aview;
    
    
    mytableview_productname=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, [array_chanpin count]*44+100) style:UITableViewStylePlain];
    mytableview_productname.delegate=self;
    mytableview_productname.dataSource=self;
    
    
    mytableview_productdetail=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320-100,[array_chanpin count]*44+100) style:UITableViewStylePlain];
    mytableview_productdetail.delegate=self;
    mytableview_productdetail.dataSource=self;
    
    scrowview_cellsc=[[UIScrollView alloc]initWithFrame:CGRectMake(100, 0, 320-100,[array_chanpin count]*44+100)];
    scrowview_cellsc.backgroundColor=[UIColor clearColor];
    [scrowview_cellsc addSubview:mytableview_productdetail];
    scrowview_cellsc.delegate=self;
    scrowview_cellsc.bounces = NO;
    scrowview_cellsc.showsVerticalScrollIndicator=NO;
    scrowview_cellsc.showsHorizontalScrollIndicator=NO;
    ///newsssss/ [aview addSubview:scrowview_cellsc];
    

    mytableview_productname.backgroundColor=[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f];
    mytableview_productdetail.backgroundColor=[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f];
    mytableview_productname.userInteractionEnabled=YES;
    mytableview_productdetail.userInteractionEnabled=YES;
    mytableview_productname.scrollEnabled=NO;
    mytableview_productdetail.scrollEnabled=NO;
    
    //productheaderdetail的名sc
    
    
    view_productnameheader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    label_nameheader=[[UILabel alloc]initWithFrame:view_productnameheader.frame];
    label_nameheader.text=@"产品";
    view_productnameheader.backgroundColor=[UIColor clearColor];
    label_nameheader.textAlignment=UITextAlignmentCenter;
    [view_productnameheader addSubview:label_nameheader];
    [aview addSubview:view_productnameheader];
    
    
    UIView *view_productdetailheader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 50)];
    view_productdetailheader.backgroundColor=[UIColor clearColor];
    if ([array_mark count]==1) {
        label_headerheader = [[UILabel alloc] initWithFrame:CGRectMake(110, 8, 100, 30)];
        label_headerheader.text = [array_mark objectAtIndex:0];
        label_headerheader.textAlignment = UITextAlignmentCenter;
        label_headerheader.backgroundColor = [UIColor blackColor];
        //label.textColor = [UIColor blackColor];
        if ([string_color isEqualToString:@"dark"]) {
            label_headerheader.textColor=[UIColor whiteColor];
        }
        else {
            label_headerheader.textColor=[UIColor blackColor];
        }
        
        [view_productdetailheader addSubview:label_headerheader];
        
    }
    else {
        for (int i = 0; i<[array_mark count]; i++) {
            
            label_headerheader = [[UILabel alloc] initWithFrame:CGRectMake(0+i*110, 8, 100, 30)];
            label_headerheader.text = [array_mark objectAtIndex:i];
            label_headerheader.textAlignment = UITextAlignmentCenter;
            label_headerheader.backgroundColor = [UIColor clearColor];
            if ([string_color isEqualToString:@"dark"]) {
                label_headerheader.textColor=[UIColor whiteColor];
            }
            else {
                label_headerheader.textColor=[UIColor blackColor];
            }
            [view_productdetailheader addSubview:label_headerheader];
        }
    }
    scrowviewheader=[[UIScrollView alloc]initWithFrame:CGRectMake(100, 0, 220, 50)];
    scrowviewheader.bounces=NO;
    scrowviewheader.pagingEnabled=YES;
    [scrowviewheader addSubview:view_productdetailheader];
    scrowviewheader.delegate=self;
    scrowviewheader.showsVerticalScrollIndicator=NO;
    scrowviewheader.showsHorizontalScrollIndicator=NO;
    scrowviewheader.backgroundColor=[UIColor clearColor];
    [aview addSubview:scrowviewheader];
    
    // [scrowview_cellsc addSubview:view_productdetailheader ];
    
    UIScrollView *scr_total=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, 320, 480-17-44-49)];
    [aview addSubview:scr_total];
    [scr_total addSubview:scrowview_cellsc];
    [scr_total addSubview:mytableview_productname];
    scr_total.backgroundColor=[UIColor clearColor];
    scr_total.contentSize=CGSizeMake(0, [array_chanpin count]*55);
    NSLog(@"chapin%d",[array_chanpin count]);
    scr_total.bounces=YES;
    scr_total.showsVerticalScrollIndicator=NO;
    scr_total.showsHorizontalScrollIndicator=NO; 
    
    if ([string_color isEqualToString:@"dark"]) {
        NSLog(@"当前是暗黑状态");
        aview.backgroundColor=[UIColor blackColor];
        
        mytableview_productname.separatorColor=[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:0.9f];
        mytableview_productdetail.separatorColor=[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:0.9f];
        label_nameheader.textColor=[UIColor whiteColor];
        
        label_headerheader.backgroundColor=[UIColor clearColor];
        label_nameheader.backgroundColor=[UIColor clearColor];
        label_nameheader.textColor=[UIColor whiteColor];
        
        
        
    }else {
        aview.backgroundColor=[UIColor whiteColor];
        mytableview_productname.separatorColor=[UIColor blackColor];
        mytableview_productdetail.separatorColor=[UIColor blackColor];
        label_nameheader.textColor=[UIColor blackColor];
        label_headerheader.backgroundColor=[UIColor clearColor];
        label_nameheader.backgroundColor=[UIColor clearColor];
        label_nameheader.textColor=[UIColor blackColor];
        
        
        
    }
    
    [self lianjie];
    
}
#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array_chanpin count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *string=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView==mytableview_productname) {
        NSLog(@"%f",cell.contentView.frame.size.height);
        label_productname=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, 90, 40)];
        label_productname.text=[array_chanpin objectAtIndex:indexPath.row];
        label_productname.backgroundColor=[UIColor clearColor];
        label_productname.textAlignment=UITextAlignmentCenter;
        [cell.contentView addSubview:label_productname];
        if ([string_color isEqualToString:@"dark"]) {
            label_productname.textColor=[UIColor whiteColor];
            lable_zhibiao.textColor=[UIColor whiteColor];
            lable_zhibiao.backgroundColor=[UIColor clearColor];
        }else {
            lable_zhibiao.textColor=[UIColor blackColor];
            label_productname.textColor=[UIColor blackColor];
            lable_zhibiao.backgroundColor=[UIColor clearColor];
            lable_zhibiao.backgroundColor=[UIColor clearColor];
            
        }
        
    }
    
    if (tableView==mytableview_productdetail) 
        
    {
        Personaldetail *userproduct=[[Personaldetail alloc]init];
        //  NSLog(@"");
        userproduct = [Personaldetail findpersonaldetailwithproductname:[array_chanpin objectAtIndex:indexPath.row]];
        
        
        NSLog(@"productArray ============================= %@ open=%@",[array_chanpin objectAtIndex:indexPath.row],userproduct.open);
        
        
        
        NSLog(@"当前是第二个tableview");
        if ([array_mark count]==1) {
            
            
            scrowview_cellsc.contentSize=CGSizeMake(0,30);
            mytableview_productdetail.frame=CGRectMake(0, 0, 220,[array_chanpin count]*44+100);
            NSLog(@"==%d",[array_mark count]);
            lable_zhibiao=[[UILabel alloc]initWithFrame:CGRectMake(110, 2, 100, 40)];
            
            lable_zhibiao.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
            
            NSString *string_ziduan=[array_mark objectAtIndex:0];
            if ([string_color isEqualToString:@"dark"]) {
                lable_zhibiao.textColor=[UIColor whiteColor];
                lable_zhibiao.backgroundColor=[UIColor clearColor];
                
            }else {
                lable_zhibiao.textColor=[UIColor blackColor];
                lable_zhibiao.backgroundColor=[UIColor clearColor];
                
            }
            
            if ([string_ziduan isEqualToString:@"报价"]) {
                lable_zhibiao.text=userproduct.open;
            }
            if ([string_ziduan isEqualToString:@"最高"]) {
                lable_zhibiao.text=userproduct.high;
            }
            if ([string_ziduan isEqualToString:@"最低"]) {
                lable_zhibiao.text=userproduct.low;
            }
            if ([string_ziduan isEqualToString:@"涨跌幅"]) {
                
                lable_zhibiao.text=[NSString stringWithFormat:@"%%%.5f",[userproduct.volume floatValue]];
            }
            if ([string_ziduan isEqualToString:@"最后更新"]) {
                int time=[userproduct.time intValue];
                NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMdd HH:mm"];//时间格式，YYYY-MM-dd HH:mm:ss:SSSS
                NSString *dateString = [dateFormat stringFromDate:nd];
                lable_zhibiao.text=dateString;
            }
            [cell.contentView addSubview:lable_zhibiao];
            scrowviewheader.contentSize=scrowview_cellsc.contentSize;
        }
        
        
        else {
            scrowview_cellsc.contentSize=CGSizeMake(([array_mark count])*110, 0);
            mytableview_productdetail.frame=CGRectMake(0, 0, 140*[array_mark count],[array_chanpin count]*44+100);
            
            NSLog(@"array_chanpin ==== %@",array_chanpin);
            for (int i=0; i<[array_mark count]; i++) {
                NSLog(@"==%d",[array_mark count]);
                lable_zhibiao=[[UILabel alloc]initWithFrame:CGRectMake(110*i, 2, 100, 40)];
                lable_zhibiao.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
                
                if ([string_color isEqualToString:@"dark"]) {
                    lable_zhibiao.textColor=[UIColor whiteColor];
                    lable_zhibiao.backgroundColor=[UIColor clearColor];
                    
                }else {
                    lable_zhibiao.textColor=[UIColor blackColor];
                    lable_zhibiao.backgroundColor=[UIColor clearColor];
                    
                }
                
                NSString *string_ziduan=[array_mark objectAtIndex:i];
                
                if ([string_ziduan isEqualToString:@"报价"]) 
                {
                    if (userproduct.open == nil) {
                        lable_zhibiao.text = @"N/A";
                    }else {
                        lable_zhibiao.text= userproduct.open;
                    }
                }
                if ([string_ziduan isEqualToString:@"最高"]) {
                    if (userproduct.high == nil) {
                        lable_zhibiao.text = @"N/A";
                    }else {
                        lable_zhibiao.text= userproduct.high;
                    }               
                }
                if ([string_ziduan isEqualToString:@"最低"]) {
                    if (userproduct.low == nil) {
                        lable_zhibiao.text = @"N/A";
                    }else {
                        lable_zhibiao.text= userproduct.low;
                    }               
                }
                if ([string_ziduan isEqualToString:@"涨跌幅"]) {
                    
                    lable_zhibiao.text=[NSString stringWithFormat:@"      %.2f%%",[userproduct.volume floatValue]];
                }
                if ([string_ziduan isEqualToString:@"最后更新"]) {
                    int time=[userproduct.time intValue];
                    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MMdd HH:mm"];//时间格式，YYYY-MM-dd HH:mm:ss:SSSS
                    NSString *dateString = [dateFormat stringFromDate:nd];
                    lable_zhibiao.text=dateString;
                }

                
                
                [cell.contentView addSubview:lable_zhibiao];
                scrowviewheader.contentSize=scrowview_cellsc.contentSize;
                scrowview_cellsc.pagingEnabled=YES;
                
            }
            
        }
        
    } 
    
    if ([string_color isEqualToString:@"dark"]) {
        label_productname.textColor=[UIColor whiteColor];
        lable_zhibiao.textColor=[UIColor whiteColor];
        lable_zhibiao.backgroundColor=[UIColor clearColor];
        
    }else {
        lable_zhibiao.textColor=[UIColor blackColor];
        label_productname.textColor=[UIColor blackColor];
        lable_zhibiao.backgroundColor=[UIColor clearColor];
        
    }
    
    return cell;  
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    
    //    MarketTableViewController * marketTable = [[MarketTableViewController alloc] init];
    //    NSString * title = [array_quanbuziduan objectAtIndex:indexPath.row];
    //    NSLog(@"%@",title);
    //    //marketTable.stringproductname=title;
    //    marketTable.array_pro=array_chanpin;
    //    marketTable.biaoji=indexPath.row;
    //    [self.navigationController pushViewController:marketTable animated:YES];
    CandleViewController *aview=[[CandleViewController alloc]init];
    aview.biaoji=indexPath.row;
    aview.array_pro=array_chanpin;
    [self.navigationController pushViewController:aview animated:NO];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    scrowviewheader.contentOffset= scrowview_cellsc.contentOffset;
    // NSLog(@"header%f\n%f",scrowviewheader.contentOffset.x,scrowview_cellsc.contentOffset.x);
    
}


#pragma mark - UISegmentedControl
- (void)mySegments:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"当前是外汇产品0");
            biaozhiwei=0;
            [self viewWillAppear:YES];
        }
            break;
        case 1:
        {
            NSLog(@"当前是贵金属1");
            biaozhiwei=1;
            [self viewWillAppear:YES];
        }
            break;
        case 2:
        {
            NSLog(@"当前是技术指标2");
            biaozhiwei=2;
            [self viewWillAppear:YES];
        }
            break;
            
            
        default:
            break;
    }
}
#pragma mark-socket连接
-(void)lianjie{
    if (_data2==nil) {
        _data2=[[data2 alloc]init];
        
    }
    
    if (socket1==nil) {
        socket1=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    NSError *err=nil;
    if(![socket1 connectToHost:stringhost onPort:[stringport intValue] error:&err]) 
    { 
        NSLog(@"连接出错");
    }else
    {
        NSLog(@"ok");
    }
    
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    if (sock==socket1)
    {
        
        NSLog(@"2cilianjie");
        NSLog(@"sessionid==%@",self.sessionid);
        NSString *request_l=[NSString stringWithFormat:@"501\\%@\\%@",self.sessionid,self.captchas];
        
        NSString *request1=[NSString stringWithFormat:@"%d\\%@",request_l.length*2,request_l];
        NSData *requestData1 = [request1 dataUsingEncoding:NSUTF16BigEndianStringEncoding];
        [socket1 writeData:requestData1 withTimeout:1000 tag:100];
        NSLog(@"request1=%@",request1);
        //  [self performSelectorInBackground:@selector(xianchengreaddata) withObject:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (1) {
                sleep(2);
                // NSData * separator1 = [@"\\" dataUsingEncoding:NSASCIIStringEncoding];
                //                for (int i=0; i<9; i++) {
                //                    [socket1 readDataToData:separator1 withTimeout:1000 tag:100+i];
                //                }
                [socket1 readDataWithTimeout:1000 tag:1000];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                
            });
        });
        
    }
    
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socket连接error");
    // [self lianjie];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{ 
    
    if (sock==socket1) {
        NSLog(@"%ld",tag);
        // NSLog(@"第二次得到的数据%");
        NSString *newMessage2 = [[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
        count++;
        
        if (count>3) {
            NSArray * arr = [newMessage2 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\\"]];
            NSLog(@"第%d次arr=======%@",count,arr);
            for (int i=0; i<[arr count]; i++) 
            {
                if ([[arr objectAtIndex:i]isEqualToString:@"1000"]||[[arr objectAtIndex:i]isEqualToString:@"1001"]) {
                    if ((i+7)<[arr count]) {
                        _data2.type=@"1000";
                        _data2.code=[arr objectAtIndex:i+1];
                        NSLog(@"code======%@",_data2.code);
                        _data2.quotetime=[arr objectAtIndex:i+2];
                        _data2.last=[arr objectAtIndex:i+3];
                        _data2.open=[arr objectAtIndex:i+4];
                        _data2.high=[arr objectAtIndex:i+5];
                        _data2.low=[arr objectAtIndex:i+6];
                        _data2.volumne=[arr objectAtIndex:i+7];
                        
                    }
                    
                    if (![_data2.code isEqualToString:@"16"]&&![_data2.code isEqualToString:@"17"]&&![_data2.code isEqualToString:@"18"]&&(i+32)<[arr count]) {
                        _data2.changne=[arr objectAtIndex:i+32];
                    }
                    array1000=[[NSArray alloc]initWithObjects:_data2.code,_data2.last,_data2.high,_data2.low,_data2.changne, nil];
                    NSLog(@"array1000%@",array1000);
                    [Personaldetail upDateWithOpen:_data2.open High:_data2.high Low:_data2.low Vlume:_data2.changne Time:_data2.quotetime fromid:_data2.code];
                    
                    [mytableview_productdetail reloadData];
                    
                }
            }
        }
        
    }
    
    
}


#pragma mark-跳转到登陆页面
-(void)login{
    LoginViewController *aviewc=[[LoginViewController alloc]init];
    [self presentModalViewController:aviewc animated:NO];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    NSLog(@"执行了改变tableviewfram");
    
}

@end
