//
//  FileSelectViewController.m
//  iChartApp
//
//  Created by vinech.SZK on 12-8-10.
//  Copyssright (c) 2012年 __MyCompanyName__. All rights reserved.
//ss

#import "FileSelectViewController.h"

@interface FileSelectViewController (){
    NSArray *array_ziduan;
    UITableViewCell *cell;
    NSMutableArray *array_rember;
    
}

@end

@implementation FileSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *aview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view=aview;
    
    tableview_file=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview_file.delegate=self;
    tableview_file.dataSource=self;
    [aview addSubview:tableview_file];
    array_ziduan=[[NSArray alloc]initWithObjects:@"报价",@"最高",@"最低",@"涨跌幅",@"最后更新",nil];
    
    UIBarButtonItem *completebtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem=completebtn;	// Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array_ziduan count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * string_cell = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:string_cell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string_cell];
    }     
    for (UIView *aView in cell.contentView.subviews) {
        [aView removeFromSuperview];
    }
    cell.textLabel.text=[array_ziduan objectAtIndex:indexPath.row];
    
    if (mark[indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.section = %d,row = %d",indexPath.section,indexPath.row);
    UITableViewCell *  cell1= [tableView cellForRowAtIndexPath:indexPath];
    mark[indexPath.row] = !mark[indexPath.row];
    
    if (!mark[indexPath.row]) 
    {
        cell1.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else {
        cell1.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    
}
-(void)complete{
    NSLog(@"chengong!");
    array_rember=[[NSMutableArray alloc]init];
    for (int i=0; i<5; i++) {
        if (mark[i]==1) {
            [array_rember addObject:[array_ziduan objectAtIndex:i]];
        }
    }
    NSUserDefaults *user_ziduan=[NSUserDefaults standardUserDefaults];
    [user_ziduan setObject:array_rember forKey:@"ziduan" ];
    [user_ziduan synchronize ];
    NSLog(@"count%d",[array_rember count]);
    
    for(int i=0;i<[array_rember count];i++)
    {
        
        NSLog(@"rember=%@",[array_rember objectAtIndex:i]);
    }
    [self.navigationController popViewControllerAnimated:YES ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
