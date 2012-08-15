//
//  LoginViewController.m
//  iChartApp
//
//  Created by bin huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "LoginViewController.h"
#import "LoginHeader.h"
#import "MarketViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController (){
    UITextField *textfield_shuruusername;
    UITextField *textfield_shurupassword;
}
@end
@implementation LoginViewController
@synthesize stringhostlogin,stringportlogin,mark_login;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    if ([socket_login connectedHost]) {
        NSLog(@"yaoxi............");
        [self dismissModalViewControllerAnimated:YES];
    }
    NSMutableArray *array_totalname=[Personaldetail findall];
    NSLog(@"totanarray=%d",[array_totalname count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *user_rem=[NSUserDefaults standardUserDefaults];
    string_rember=[user_rem objectForKey:@"rem"];
    
    NSLog(@"viewdiload");
    mark_login=0;
    data1=[[data alloc]init];
    
    UIView *aview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view =aview;
    aview.backgroundColor=[UIColor blackColor];
    aview.alpha=0.95;
    
    UITextField *textfield_username=[[UITextField alloc]initWithFrame:rect_textfieldusername];
    [aview addSubview:textfield_username];
    textfield_username.backgroundColor=[UIColor clearColor];
    textfield_username.text=@"Username";
    textfield_username.textColor=[UIColor whiteColor];
    textfield_username.userInteractionEnabled=NO;
    
    textfield_shuruusername=[[UITextField alloc]initWithFrame:rect_textfieldshuruusername];
    [aview addSubview:textfield_shuruusername];
    textfield_shuruusername.backgroundColor=[UIColor whiteColor];
    textfield_shuruusername.textColor=[UIColor blackColor];
    if ([string_rember isEqualToString:@"rem"]) {
        NSUserDefaults *user_username=[NSUserDefaults standardUserDefaults];
        textfield_shuruusername.text=[user_username objectForKey:@"remberusername"];
        NSLog(@"remberusername%@",textfield_shuruusername.text);
        
    }
    
    UITextField *textfield_password=[[UITextField alloc]initWithFrame:rect_textfieldpassword];
    [aview addSubview:textfield_password];
    textfield_password.backgroundColor=[UIColor clearColor];
    textfield_password.text=@"Password";
    textfield_password.userInteractionEnabled=NO;
    textfield_password.textColor=[UIColor whiteColor];
    
    textfield_shurupassword=[[UITextField alloc]initWithFrame:rect_textfieldshurupassword];
    [aview addSubview:textfield_shurupassword];
    textfield_shurupassword.secureTextEntry=YES;
    textfield_shurupassword.backgroundColor=[UIColor whiteColor];
    textfield_shurupassword.textColor=[UIColor blackColor];
    if ([string_rember isEqualToString:@"rem"]) {
        NSUserDefaults *user_password1=[NSUserDefaults standardUserDefaults];
        textfield_shurupassword.text=[user_password1 objectForKey:@"remberpassword"];
        NSLog(@"remberpassword%@",textfield_shurupassword.text);
    }
    
    
    UIButton *button_login=[[UIButton alloc]initWithFrame:rect_buttonlogin];
    [button_login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    // button_login.titleLabel.text=@"Sign in";
    [button_login setTitle:@"登陆" forState:UIControlStateNormal];
    button_login.titleLabel.textColor=[UIColor blackColor];
    button_login.backgroundColor=[UIColor whiteColor];
    [aview addSubview:button_login];
    
    UIButton *button_regin=[[UIButton alloc]initWithFrame:rect_buttonregister];
    [button_regin addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];
    // button_login.titleLabel.text=@"Sign in";
    [button_regin setTitle:@"注册" forState:UIControlStateNormal];
    button_regin.titleLabel.textColor=[UIColor blackColor];
    button_regin.backgroundColor=[UIColor whiteColor];
    [aview addSubview:button_regin];
    //记住密码和自动登陆
    label_rember =[[UILabel alloc]initWithFrame:rect_labelrember];
    if (string_rember==nil||[string_rember isEqualToString:@"notrem"]) {
        label_rember.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_check@2x.png"]];
        string_rember=@"notrem";
    }else {
        label_rember.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_checked@2x.png"]];
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rember)];
    [tap setNumberOfTapsRequired:1];
    [label_rember addGestureRecognizer:tap];
    label_rember.userInteractionEnabled=YES;
    [aview addSubview:label_rember];
    
    NSUserDefaults *user_arc=[NSUserDefaults standardUserDefaults];
    string_arlog=[user_arc objectForKey:@"arc"];
    label_arlog =[[UILabel alloc]initWithFrame:rect_labelarlog];
    if (string_arlog==nil||[string_arlog isEqualToString:@"notarc"]) {
        label_arlog.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_check@2x.png"]];
        string_arlog=@"notarc";
    }else {
        label_arlog.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_checked@2x.png"]];
    }
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(arlog)];
    [tap1 setNumberOfTapsRequired:1];
    [label_arlog addGestureRecognizer:tap1];
    label_arlog.userInteractionEnabled=YES;
    [aview addSubview:label_arlog];
    //记住密码和自动登陆的label
    label_left=[[UILabel alloc]initWithFrame:rect_labelleft];
    label_left.text=@"记住密码";
    [aview addSubview:label_left];
    
    label_right=[[UILabel alloc]initWithFrame:rect_labelright];
    label_right.text=@"自动登陆";
    [aview addSubview:label_right];
    //如果用户选择自动登陆，并且用户名和密码不为空，则执行登陆的方法
    if ([string_arlog isEqualToString:@"arc"]) {
        [self login];
    }
    
    
    
 	////newsssss Do any additional setup after loading the view.
}

#pragma mark-记住密码和自动登陆
-(void)rember{
    NSLog(@"yaoxi");
    if ([string_rember isEqualToString:@"notrem"]) {
        label_rember.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_checked@2x.png"]];
        string_rember = @"rem";
        
    }else {
        label_rember.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_check@2x.png"]];
        string_rember = @"notrem";
        
        
    } 
    NSLog(@"stringrem = %@",string_rember);
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    [user setObject:string_rember forKey:@"rem"];
    [user synchronize];
}
-(void)arlog{
    NSLog(@"yaoxi");
    if ([string_arlog isEqualToString:@"notarc"]) {
        label_arlog.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_checked@2x.png"]];
        
        string_arlog = @"arc";
        
    }else {
        label_arlog.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"com_btn_check@2x.png"]];
        string_arlog = @"notarc";
        
    } 
    NSLog(@"stringarc = %@",string_arlog);
    NSUserDefaults * user1=[NSUserDefaults standardUserDefaults];
    [user1 setObject:string_arlog forKey:@"arc"];
    [user1 synchronize];
    
}

#pragma mark-进入注册界面
-(void)register{
    RegisterViewController *aview=[[RegisterViewController alloc]init];
    [self presentModalViewController:aview animated:YES];
}
#pragma mark-登陆请求数据

-(void)login{
    // [self dismissModalViewControllerAnimated:YES];
    //    NSLog(@"yaoxi");
    if ([string_rember isEqualToString:@"rem"]) {
        NSUserDefaults *user_username=[NSUserDefaults standardUserDefaults];
        [user_username setObject:textfield_shuruusername.text forKey:@"remberusername"];
        [user_username synchronize];
        
        NSUserDefaults *user_password=[NSUserDefaults standardUserDefaults];
        [user_password setObject:textfield_shurupassword.text forKey:@"remberpassword"];
        [user_password synchronize];
        
    }
    
    socket_login= [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil; 
    if(![socket_login connectToHost:@"222.73.211.226" onPort:25010 error:&err]) 
    { 
        NSLog(@"连接出错");
        
    }else
    {
        NSLog(@"ok");
    }
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    NSString *request_l=[NSString stringWithFormat:@"101\\%@\\%@",textfield_shuruusername.text,textfield_shurupassword.text];
    NSString *request=[NSString stringWithFormat:@"%d\\%@",request_l.length*2,request_l];
    NSData *requestData = [request dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    [socket_login writeData:requestData withTimeout:1000 tag:0];
    
    NSData * separator = [@"\\" dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"separtor====%@",separator);
    for (int i=0; i<7; i++) {
        if (i<6) {
            [socket_login readDataToData:separator withTimeout:1000 tag:i];
            NSLog(@"%d....",i);
        }
        if (i==6) {
            [socket_login readDataWithTimeout:1000 tag:6];
            NSLog(@"%d....",i);
            
        }
    }
    //    if (<#condition#>) {
    //        <#statements#>
    //    }
    //   [socket_login readDataWithTimeout:1000 tag:5];
    // [socket_login readDataWithTimeout:1000 tag:3];
    
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{ 
    
    NSLog(@"tag%ld",tag);
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
    newMessage = [newMessage stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    // NSLog(@"=======%@",newMessage);
    switch (tag) {
        case 0:
            data1.messagelength=[newMessage intValue];
            if (data1.messagelength==404) {
                //                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                //                [alertview show];
                
            }
            NSLog(@"changdu========%d",data1.messagelength);
            break;
        case 1:
            data1.type=[newMessage intValue];
            if (data1.type==0) {
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"nil" otherButtonTitles:nil, nil];
                [alertview show];
                
            }
            break;
        case 2:
        {
            NSLog(@"newmenssage=====%@,,,,",newMessage);
            
            if ([newMessage intValue]>0) {
                data1.publisherIPandPort=[NSString stringWithFormat:newMessage];
                NSString *stringbiaoshi=@":";
                NSRange range1=[data1.publisherIPandPort rangeOfString:stringbiaoshi];
                stringhostlogin=[data1.publisherIPandPort substringWithRange:NSMakeRange(0, range1.location)];
                stringportlogin = [data1.publisherIPandPort substringFromIndex:range1.location+1];
                NSLog(@"publisherIPandPort======================%@",data1.publisherIPandPort);
                NSLog(@"stringport====%@",stringportlogin);
                NSLog(@"host===%@",stringhostlogin);
                NSUserDefaults *userstringhost=[NSUserDefaults standardUserDefaults];
                [userstringhost setObject:stringhostlogin forKey:@"host"];
                [userstringhost synchronize];
                
                NSUserDefaults *userstringport=[NSUserDefaults standardUserDefaults];
                [userstringport setObject:stringportlogin forKey:@"port"];
                [userstringport synchronize];
            }
            
            
            break;
            
        }
        case 3:{
            data1.sessionID=[NSString stringWithFormat:newMessage];
            data1.sessionidlength=data1.sessionID.length;
            NSLog(@"data1.sessionID======%@",data1.sessionID);
            NSUserDefaults *userid=[NSUserDefaults standardUserDefaults];
            [userid setObject:data1.sessionID forKey:@"id"];
            [userid synchronize];
            
            
            break;}
        case 4:
        {
            data1.captchas=[NSString stringWithFormat:newMessage];
            NSLog(@"captchas===%@",data1.captchas);
            data1.captchaslength=data1.captchas.length;
            data1.totallength=(3+1+data1.sessionidlength+1+data1.captchaslength)*2;
            NSLog(@"totallength===========%d",data1.totallength);
            NSUserDefaults *usercaptchas=[NSUserDefaults standardUserDefaults];
            [usercaptchas setObject:data1.captchas forKey:@"captchas"];
            [usercaptchas synchronize];
            break;
        }
            
        case 5:{
            NSLog(@"resultstring====%@",newMessage);
            data1.result=[newMessage intValue];
        }            
            // [self performSelectorInBackground:@selector(nihao) withObject:nil];
            
            break;
        case 6:{
            NSLog(@"newMessage======%@",newMessage);
            data1.ndicate=[NSString stringWithFormat:newMessage];
           // [Personaldetail addproductname:@"ss" id:@"12" type:@"32"];
           // NSString * str = @"AgT+D,1,1/AuT+D,2,1/USD,3,3/AG1207,4,1/AG1208,5,1/AG1209,6,1/AG1210,7,1/AG1211,8,1/AG1212,9,1/AG1301,10,1/AG1302,11,1/AG1303,12,1/AG1304,13,1/AG1305,14,1/AG1306,15,1/XAGUSD,16,1/PD,17,1/PT,18,1";
         NSString * str = [NSString stringWithFormat:newMessage];

         
            NSArray   *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];//去掉斜杠，把字符串转化成数组
            NSLog(@"%@",arr);
            NSString * str1=@",";
            NSMutableArray * array_name = [[NSMutableArray alloc] init];
            NSMutableArray * array_id = [[NSMutableArray alloc] init];
            NSMutableArray * array_type = [[NSMutableArray alloc] init];
            for (NSString * ing in arr) {
                NSRange range = [ing rangeOfString:str1];
                NSString * str3 = [ing substringToIndex:range.location] ;
                NSString * str4 = [ing substringFromIndex:range.location+1];
                
                NSRange range1 =[str4 rangeOfString:str1];
                NSString * str5 = [str4 substringToIndex:range1.location];
                NSString * str6 = [str4 substringFromIndex:range1.location+1];
                [array_id addObject:str5];
                [array_type addObject:str6];
                [array_name addObject:str3];
            }
            NSMutableArray *array_totalname=[Personaldetail findall];
            NSLog(@"totanarray=%d",[array_totalname count]);
            
            NSLog(@"arrayname = %@,%d",array_name,array_name .count);
            NSLog(@"arrayid = %@,%d",array_id,array_id .count);
            NSLog(@"arraytype = %@,%d",array_type,array_type .count);
            if ([array_totalname count]<[array_name count]) {
                for (int i=[array_name count]; i>[array_totalname count]; i--) {
                    [ Personaldetail addproductname:[array_name objectAtIndex:i-1] id:[array_id objectAtIndex:i-1] type:[array_type objectAtIndex:i-1]];
                }
            }else {
                NSLog(@"数据库不需要更新");
            }
            
            [self performSelector:@selector(backtorootviewC)];
            
            // data1.re=[newMessage intValue];
        }            
            
            break;
            
            
            
        default:
            break;
    }   
}
-(void)backtorootviewC{
    NSLog(@"data1.result==%d",data1.result);
    UIAlertView *alertview;
    switch (data1.result) {
        case 1:
        {
            [self dismissModalViewControllerAnimated:NO];
            // MarketViewController *aview=[[MarketViewController alloc]init];
            // [self.navigationController pushViewController:aview animated:NO];
            // [self presentModalViewController:aview animated:NO];
            
        }
            break;
        case 2:{
            alertview=[[UIAlertView alloc]initWithTitle:@"登录失败" message:@"用户不存在" delegate:nil cancelButtonTitle:@"请重新登陆" otherButtonTitles:nil, nil];
            [alertview show];
        }
            
            break;
        case 3:
        {
            alertview=[[UIAlertView alloc]initWithTitle:@"登录失败" message:@"密码不正确" delegate:nil cancelButtonTitle:@"请重新登录" otherButtonTitles:nil, nil];
            [alertview show];
        }
            break;
        case 4:
        {
            alertview=[[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"服务器未启动" delegate:nil cancelButtonTitle:@"请稍后登陆" otherButtonTitles:nil, nil];
            [alertview show];
        }
            break;
        case 8:
        {
            alertview=[[UIAlertView alloc]initWithTitle:@"登录失败" message:@"帐号过期" delegate:nil cancelButtonTitle:@"请重新申请帐号" otherButtonTitles:nil, nil];
            [alertview show];
        }
            break;
        case 9:
        {
            alertview=[[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"帐号未激活" delegate:nil cancelButtonTitle:@"请激活后登陆" otherButtonTitles:nil, nil];
            [alertview show];
        }
            break;
            
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self viewDidLoad];
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
