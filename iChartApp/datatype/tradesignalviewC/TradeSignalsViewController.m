//
//  TradeSignalsViewController.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TradeSignalsViewController.h"
#import "TradeSignalCell.h"
#import "MarketTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TradeSignalsViewController (){
    UITableView * tabV;
    NSString *string;
    NSString *style;
    UIScrollView * scrollV;
    NSArray * array;
    NSArray * array1;
    NSArray * array2;
    NSArray * array3;
    NSArray * array4;
    NSArray * array5;
    UIView * aView;
    UISearchBar * searchBar1;
    
}


@end

@implementation TradeSignalsViewController
@synthesize Aa;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
   
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    string = [user objectForKey:@"style"];
    NSLog(@"viewvillappear..string ==================== ========================================%@",string);
    if ([style isEqualToString:string]==NO) {
        NSLog(@"执行了viewdiload");
        [self viewDidLoad];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (string==nil) {
        string=@"dark";
        style=@"dark";
    }
    else {
        style=[NSString stringWithFormat:string];
    }
    
    [super loadView];
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = aView;
    
    
    UIBarButtonItem * userNameButton = [[UIBarButtonItem alloc] initWithTitle:@"信号" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem = userNameButton;
    
    
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,40)];
    dateLabel.text = @"Date:2012/6/24  TIME:12/44/12";
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.backgroundColor = [UIColor clearColor];
    [aView addSubview:dateLabel];
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320,40)];
    
    
    UIButton * searchDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchDateButton.frame = CGRectMake(20,5,110,30);
    [searchDateButton setTitle:@"时间检索" forState:UIControlStateNormal];
    [searchDateButton addTarget:self action:@selector(searchDate) forControlEvents:UIControlEventTouchUpInside];
    searchDateButton.layer.cornerRadius = 8;
    
    
    
    
    
    UIImageView * downImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(95,10,10,10)];
    downImageVIew.image = [UIImage imageNamed:@"toggle-arrow.png"];
    downImageVIew.backgroundColor = [UIColor clearColor];
    
    
    searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(150,5,170,30)];
    searchBar1.showsCancelButton = NO;
    searchBar1.barStyle = UIBarStyleDefault;
    searchBar1.placeholder = @"内容检索";
    searchBar1.delegate = self;
    searchBar1.keyboardType = UIKeyboardTypeDefault;
    searchBar1.backgroundColor = [UIColor clearColor];
    
    for (UIView *subview in searchBar1.subviews)   
    {    
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])  
        {    
            [subview removeFromSuperview];    
            break;  
        }   
    } 
    
    [searchView addSubview:searchBar1];
    [aView addSubview:searchView];
    [searchView addSubview:searchDateButton];
    [searchDateButton addSubview:downImageVIew];    
    
    
    scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, 320, 480-100-44-49)];
    scrollV.showsHorizontalScrollIndicator = YES;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.pagingEnabled = YES;
    scrollV.bounces = NO;
    [scrollV setContentSize:CGSizeMake(640,0)];
    [aView addSubview:scrollV];    
    
    tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 640, 380-44-49) style:UITableViewStylePlain];
    tabV.delegate = self;
    tabV.dataSource=self;
    tabV.rowHeight = 70;
    [scrollV addSubview:tabV];
    
    array = [[NSArray alloc ] initWithObjects:@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出",@"买入",@"卖出", nil];
    
    array1 = [[NSArray alloc ] initWithObjects:@"EUR/USD",@"USD/EUR",@"GBP/AUD",@"NZD/USD",@"EUR/JPY",@"GBP/CHF",@"EUR/USD",@"USD/EUR",@"GBP/AUD",@"NZD/USD",@"EUR/JPY",@"GBP/CHF",@"EUR/USD",@"USD/EUR",@"GBP/AUD",@"NZD/USD",@"EUR/JPY",@"GBP/CHF",@"EUR/JPY",@"GBP/CHF",nil];
    
    array2= [[NSArray alloc ] initWithObjects:@"125.43",@"236.2",@"2425.3",@"988.664",@"4323.3",@"3.3200",@"12.53",@"23.43",@"5.65",@"103.2",@"678.4",@"342",@"43",@"6.44",@"6.433",@"765.76",@"901",@"623.32",@"999.99",@"432.31", nil];
    
    array3= [[NSArray alloc ] initWithObjects:@"120.43",@"43",@"999.99",@"432.31",@"28",@"2865.7",@"2324.2",@"973",@"421",@"6.423",@"3732.3",@"2346.4",@"3456.6",@"888.88",@"4323.3",@"3.3200",@"12.53",@"23.43",@"5.65",@"6.44",nil];
    
    array4= [[NSArray alloc ] initWithObjects:@"1213.43",@"4323.3",@"3.3200",@"12.53",@"23.43",@"5.65",@"6.44",@"6.433",@"765.76",@"901",@"623.32",@"103.2",@"678.4",@"342",@"6.423",@"3732.3",@"2346.4",@"3456.6",@"888.88",@"432.4", nil];
    
    array5= [[NSArray alloc ] initWithObjects:@"13.43",@"-323.3",@"3.30",@"-2.53",@"83.43",@"-45.65",@"6.44",@"-8.433",@"65.76",@"-901",@"623.32",@"-03.2",@"-8.4",@"342",@"-6.423",@"-332.3",@"46.4",@"-96.6",@"78.88",@"-52.23",nil];
    
    Aa = 1;
    
    if ([style isEqualToString:@"dark"]) {
        aView.backgroundColor = [UIColor blackColor];
        dateLabel.textColor = [UIColor whiteColor];
        searchDateButton.backgroundColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
        tabV .backgroundColor = [UIColor blackColor];
        searchView.backgroundColor = [UIColor blackColor];





    }
    else {
        aView.backgroundColor = [UIColor whiteColor];
        dateLabel.textColor = [UIColor blackColor];
        searchDateButton.backgroundColor = [UIColor lightGrayColor];
        tabV .backgroundColor = [UIColor whiteColor];
        searchView.backgroundColor = [UIColor whiteColor];





    }
    
    
	// Do any additional setup after loading the view.
}
//不让弹出键盘

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return NO;
}
-(void)searchDate
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"按时间查找" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"一天前",@"一周前",@"一月前",nil];
    actionSheet.frame = CGRectMake(0,300,320,160);
    
    [actionSheet showInView:self.view.window];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringcell = @"cell";
    TradeSignalCell * cell = [tableView dequeueReusableCellWithIdentifier:stringcell];
    if (cell == nil) {
        cell = [[TradeSignalCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:stringcell];
    }
    
    cell.label1.text = [array objectAtIndex:indexPath.row];
    cell.label2.text = [array1 objectAtIndex:indexPath.row];
    cell.label3.text = [array2 objectAtIndex:indexPath.row];
    cell.label4.text = [array3 objectAtIndex:indexPath.row];
    cell.label5.text = [array4 objectAtIndex:indexPath.row];
    cell.label6.text = [array5 objectAtIndex:indexPath.row];
    cell.label7.text = @"2012-06-24 9:45:34";
    if ([style isEqualToString:@"dark"]) {
        cell.label1.textColor=[UIColor whiteColor];
        cell.label2.textColor=[UIColor whiteColor];
        cell.label3.textColor=[UIColor whiteColor];
        cell.label4.textColor=[UIColor whiteColor];
        cell.label5.textColor=[UIColor whiteColor];
        cell.label6.textColor=[UIColor whiteColor];
        cell.label7.textColor=[UIColor whiteColor];

    }
    else {
        cell.label1.textColor=[UIColor blackColor];
        cell.label2.textColor=[UIColor blackColor];
        cell.label3.textColor=[UIColor blackColor];
        cell.label4.textColor=[UIColor blackColor];
        cell.label5.textColor=[UIColor blackColor];
        cell.label6.textColor=[UIColor blackColor];
        cell.label7.textColor=[UIColor blackColor];
        

        
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketTableViewController * marketTab = [[MarketTableViewController   alloc] init];
    marketTab.Aa =Aa;
    [self.navigationController pushViewController:marketTab animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    viewHeader.backgroundColor = [UIColor clearColor];
    viewHeader.alpha = 0.7;
    NSArray * arrays = [NSArray arrayWithObjects:@"指令",@"产品",@"价格",@"止损",@"目标",@"盈亏",nil];
    for (int i = 0; i<6; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0+i*110, -5, 100, 30)];
        label.text = [arrays objectAtIndex:i];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        if ([style isEqualToString:@"dark"]) {
            label.textColor = [UIColor whiteColor];
        

        }else {
            label.textColor=[UIColor blackColor];
        }
        [viewHeader addSubview:label];
    }
    return viewHeader;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) { 
        aView.frame=CGRectMake(0, 0, 480, 320-44-49);
        scrollV.frame=CGRectMake(0, 80, 480, 320-44-49);
        scrollV.contentSize=CGSizeMake(700, 100);
       tabV.frame=CGRectMake(0, 0,700, 320-44-49);
        NSLog(@"执行了改变tableviewfram");
    } 
    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) { 
        aView.frame=CGRectMake(0, 0, 480, 320-44-49);
        scrollV.frame=CGRectMake(0, 80, 480, 320-44-49);
        tabV.frame=CGRectMake(0, 0, 480, 320-44-49);
        NSLog(@"执行了改变tableviewfram");

        
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortrait) { 
       // tabV.frame=CGRectMake(0,0,320,460-44-49);
        [self viewDidLoad];
        
        //shang 
    } 
    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) { 
       // tabV.frame=CGRectMake(0,0,320,460-44-49);
        [self viewDidLoad];
        //xia 
    } 
    

    
    return YES;
}

@end
