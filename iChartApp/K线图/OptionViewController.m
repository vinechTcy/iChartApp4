//
//  OptionViewController.m
//  chartee
//
//  Created by Tcy vinech on 12-7-25.
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import "OptionViewController.h"
#import "CandleViewController.h"
@interface OptionViewController ()

@end

@implementation OptionViewController
@synthesize arrTitle = _arrTitle;
@synthesize arrCheck = _arrCheck;
@synthesize arrValue = _arrValue;
@synthesize segmentTitle = _segmentTitle;
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
    
    UIView * aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    aView.backgroundColor = [UIColor blackColor];
    self.view = aView;
    
    UIView * viewNavgation = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 40)];
    viewNavgation.backgroundColor = [UIColor colorWithRed:56/255.0f green:99/255.0f blue:185/255.0f alpha:1.0];
    [self.view addSubview:viewNavgation];
    
    UIButton *backButton = [UIButton     buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(10, 5, 50, 30);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [viewNavgation addSubview:backButton];
    
    UIButton *editButton = [UIButton     buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame = CGRectMake(260, 5, 50, 30);
    [editButton setTitle:@"Save" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewNavgation addSubview:editButton];
    
    
    UIScrollView * scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 320, 480)];
    scrollV.backgroundColor = [UIColor blackColor];
    scrollV.userInteractionEnabled =YES;
    scrollV.contentSize = CGSizeMake(320, 480);
    [aView addSubview:scrollV];
    
    //    
    NSArray *labelTitle = [[NSArray alloc] initWithObjects:@"1 Minute (m1)",@"5 Minutes (m5)",@"15 Minutes (m15)",@"30 Minutes (m30)",@"1 Hour (H1)",@"1 Day (D1)",@"1 Week (W1)",@"1 Month (M1)",nil];
    
    _arrTitle = [[NSArray alloc] initWithObjects:@"1 Minute (m1)-1",@"5 Minutes (m5)-5",@"15 Minutes (m15)-15",@"30 Minutes (m30)-30",@"1 Hour (H1)-60",@"1 Day (D1)-1440",@"1 Week (W1)-10080",@"1 Month (M1)-43200",nil];
    
    for (int i=0;i<[labelTitle count];i++) {
		UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(30,40+i*50,42,42)];	
		[btn setBackgroundImage:[UIImage imageNamed:@"com_btn_check@2x.png"] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"com_btn_checked@2x.png"] forState:UIControlStateSelected];
        [btn setTag:i];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setTitle:[_arrTitle objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:(@selector(chooseBox1:)) forControlEvents:UIControlEventTouchUpInside];
        label=[[UILabel alloc] initWithFrame:CGRectMake(90,40+i*50,160, 32)];
        label.textColor=[UIColor redColor];
        label.backgroundColor=[UIColor clearColor];
        label.text = [labelTitle objectAtIndex:i];
        label.tag = i+10;
        label.font = [UIFont systemFontOfSize:16];
        [scrollV addSubview:label];
		[scrollV addSubview:btn];
	}
    NSLog(@"%d",[_arrTitle count]);
    _arrCheck = [[NSMutableArray alloc] init];
    _arrValue = [[NSMutableArray alloc] init];
}
- (void)chooseBox1:(UIButton *)sender{
    isChecked1[sender.tag] = !isChecked1[sender.tag];
    
	if (isChecked1[sender.tag]) {
		sender.selected = YES;
        if ([_arrCheck count]<6) {
            
            NSRange range = [sender.titleLabel.text rangeOfString:@"("];
            _segmentTitle = [sender.titleLabel.text substringFromIndex:range.location];
            NSRange range1=[_segmentTitle rangeOfString:@")"];
            _segmentTitle = [[sender.titleLabel.text substringWithRange:NSMakeRange(range.location, range1.location)]stringByReplacingOccurrencesOfString:@"(" withString:@""];
            
            NSRange range2= [sender.titleLabel.text rangeOfString:@"-"];
            NSString *_segmentValue = [[sender.titleLabel.text substringFromIndex:range2.location] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            [_arrCheck addObject:_segmentTitle];
            [_arrValue addObject:_segmentValue];
            NSLog(@"%@ == %@",_arrCheck,_arrValue);
            if ([_arrCheck count]==6) {
                [_arrCheck addObject:@".."];
            }
        }else {
            sender.selected = NO;
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"最多添加6项" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertV show];
        }
        
	}else {
        
		sender.selected = NO;
        NSRange range = [sender.titleLabel.text rangeOfString:@"("];
        _segmentTitle = [sender.titleLabel.text substringFromIndex:range.location];
        NSRange range1=[_segmentTitle rangeOfString:@")"];
        _segmentTitle = [[sender.titleLabel.text substringWithRange:NSMakeRange(range.location, range1.location)]stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSRange range2= [sender.titleLabel.text rangeOfString:@"-"];
        NSString *_segmentValue = [[sender.titleLabel.text substringFromIndex:range2.location] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [_arrCheck removeObject:_segmentTitle];
        [_arrValue removeObject:_segmentValue];
        [_arrCheck removeObject:@".."];
        NSLog(@"%@ == %@",_arrCheck,_arrValue);
	}
}

- (void)saveButton:(UIButton *)sender
{
    if ([_arrCheck count]<=6) {
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"至少要添加6项" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertV show];
    }else {
//       // CandleViewController * candleV = [[CandleViewController alloc] init];
//        candleV.arrTitle = self.arrCheck;
//        candleV.arrValue = self.arrValue;
//        candleV.arrayEdit =YES;
//        // [candleV viewDidLoad];
//        [self presentModalViewController:candleV animated:YES];
        
        
    }
}

- (void)backButton
{
    [self dismissModalViewControllerAnimated:YES];
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
