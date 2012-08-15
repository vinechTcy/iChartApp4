//
//  ProductSelectViewController.m
//  iChartApp
//
//  Created by bin huang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductSelectViewController.h"

@interface ProductSelectViewController (){
    UIView *aview;
    CGRect rect_aview;
    CGRect rect_tableview;
    NSString *popTitle;
    NSString *string;
    NSString *style;
    UITableViewCell * cell;
    
    NSUserDefaults *user_forex;
    NSUserDefaults *user_preciousmetal;
    NSUserDefaults *user_exponent;
    
    NSMutableArray *arraywaihui;
    NSMutableArray *arrayguijinshu;
    NSMutableArray *arrayzhishu;
    
    NSArray *array_forex;
    NSArray *array_preciousmetal;
    NSArray *array_exponent;
    
}

@end

@implementation ProductSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    // NSUserDefaults *user=[[NSUserDefaults alloc]initWithUser:<#(NSString *)#>];
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
    
    if (string==nil) {
        string=@"dark";
        style=@"dark";
    }
    else {
        style=[NSString stringWithFormat:string];
    }
    
    [super viewDidLoad];
    aview=[[UIView alloc]initWithFrame:rect_aview];
    self.view = aview;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    arraywaihui=[[NSMutableArray alloc]init];
    arrayguijinshu=[[NSMutableArray alloc]init];
    arrayzhishu=[[NSMutableArray alloc]init];
    
    popTitle=@"返回";
    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:popTitle style:UIBarButtonItemStyleDone target:self action:@selector(backbtn)];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UIBarButtonItem *completebtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem=completebtn;
    
    tableview_product=[[UITableView alloc]initWithFrame:rect_tableview style:UITableViewStyleGrouped];
    array_section=[[NSArray alloc]initWithObjects:@"外汇",@"贵金属",@"指数", nil];    
    array_forex=[[NSArray alloc]initWithObjects:@"美元指数",nil];
    
    array_preciousmetal=[[NSArray alloc]initWithObjects:@"现货白银",@"白银T+D",@"黄金T+D",@"AG1207",@"AG1208",@"AG1209",@"AG1210",@"AG1211",@"AG1212",@"AG1301",@"AG1302",@"AG1303",@"AG1304",@"AG1305",@"AG1306",@"PD",@"PT",nil];
    array_exponent=[[NSArray alloc]initWithObjects:nil, nil];
    array_row=[[NSMutableArray alloc]initWithObjects:array_forex,array_preciousmetal,array_exponent,nil];
    [aview addSubview:tableview_product];
    
    tableview_product.delegate=self;
    tableview_product.dataSource=self;
    
    if ([style isEqualToString:@"dark"]) {
        aview.backgroundColor=[UIColor blackColor];
        tableview_product.backgroundColor=[UIColor blackColor];
        tableview_product.separatorColor=[UIColor whiteColor];
    }
    else {
        aview.backgroundColor=[UIColor whiteColor];
        tableview_product.backgroundColor=[UIColor whiteColor];
        tableview_product.separatorColor=[UIColor blackColor];
        
        
    }
	// Do any additional setup after loading the view.
}
#pragma tableviewdatasource tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array_section count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[array_row objectAtIndex:section] count];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    arraywaihui=[[NSMutableArray alloc]init];
    
    NSLog(@"indexPath.section = %d,row = %d",indexPath.section,indexPath.row);
    UITableViewCell *  cell1= [tableView cellForRowAtIndexPath:indexPath];
    mark[indexPath.section][indexPath.row] = !mark[indexPath.section][indexPath.row];
    
    if (!mark[indexPath.section][indexPath.row]) 
    {
        cell1.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else {
        cell1.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    
    //  NSUserDefaults *user=
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * string_cell = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:string_cell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string_cell];
    }     
    for (UIView *aView in cell.contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    cell.textLabel.text=[[array_row objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    if ([style isEqualToString:@"dark"]) {
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor blackColor];
    }
    else {
        cell.textLabel.textColor=[UIColor blackColor];
        cell.backgroundColor=[UIColor whiteColor];
    }
    if (mark[indexPath.section][indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
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
    
    label.textAlignment = UITextAlignmentLeft;
    label.text = [array_section objectAtIndex:section];
    if ([style isEqualToString:@"dark"]) {
        label.textColor=[UIColor whiteColor];
    }else {
        label.textColor=[UIColor blackColor];
    }
    view.backgroundColor=[UIColor clearColor];
    
    
    [view addSubview:label];
    
    
    return view;
}


#pragma 返回到设置界面
-(void)backbtn{
    // MarketViewController *aview=[[MarketViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)complete
{
    for (int i=0; i<3; i++) {
        for (int j=0; j<30; j++) {
            NSLog(@"%d",mark[i][j]);
            
            switch (i) {
                case 0:
                    if (mark[0][j]) {
                        [arraywaihui addObject:[array_forex objectAtIndex:j]];
                        
                    }
                    break;
                    
                case 1:
                    if (mark[1][j]) {
                        [arrayguijinshu addObject:[array_preciousmetal objectAtIndex:j]];
                    }
                    break;
                    
                case 2:
                    if (mark[2][j]) {
                        [arrayzhishu addObject:[array_exponent objectAtIndex:j]];
                        
                    }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    
    user_forex=[NSUserDefaults standardUserDefaults];
    [user_forex setObject:arraywaihui forKey:@"forex"];
    [user_forex synchronize];
    NSLog(@"waihui===%@",arraywaihui);
    
    user_preciousmetal=[NSUserDefaults standardUserDefaults];
    [user_preciousmetal setObject:arrayguijinshu forKey:@"preciousmetal"];
    [user_preciousmetal synchronize];
    NSLog(@"GUIJINSHU===%@",arrayguijinshu);
    
    user_exponent=[NSUserDefaults standardUserDefaults];
    [user_exponent setObject:arrayzhishu forKey:@"exponent"];
    [user_exponent synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if (interfaceOrientation==UIInterfaceOrientationPortrait||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
        rect_aview=CGRectMake(0, 0, 320, 480);
        aview.frame=CGRectMake(0, 0, 320, 480);
        rect_tableview=CGRectMake(0, 0, 320, 480-44-60);
        tableview_product.frame=CGRectMake(0, 0, 320, 480-44-60);
        
    }
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        rect_aview=CGRectMake(0, 0, 480, 320);
        aview.frame=CGRectMake(0, 0, 480, 320-44-55);
        rect_tableview=CGRectMake(0, 0, 480, 320-44-55);
        tableview_product.frame=CGRectMake(0, 0, 480, 320-44-55);
        
    }
    return YES;
}

@end
