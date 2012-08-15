//
//  RegisterViewController.m
//  iChartApp
//
//  Created by bin huang on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "regisHeader.h"
#import "data.h"
#import "LoginViewController.h"
@interface RegisterViewController (){
    data *data1;
}

@end

@implementation RegisterViewController

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
    socket_register= [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    data1=[[data alloc]init];
    UIView *aview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    aview.backgroundColor=[UIColor lightGrayColor];
    self.view=aview;
    
    text_username=[[UITextField alloc]initWithFrame:rect_username];
    text_username.text=@"用户名：";
    text_username.userInteractionEnabled=NO;
    text_username.textAlignment=UITextAlignmentCenter;
    text_username.backgroundColor=[UIColor clearColor];
    text_username.textColor=[UIColor blackColor];
    [aview addSubview:text_username];
    
    text_usernameshuru=[[UITextField alloc]initWithFrame:rect_usernameshuru];
    text_usernameshuru.backgroundColor=[UIColor lightTextColor];
    text_usernameshuru.textColor=[UIColor blackColor];
    text_emailshuru.delegate=self;
    [aview addSubview:text_usernameshuru];

    text_password=[[UITextField alloc]initWithFrame:rect_password];
    text_password.text=@"密码:";
    text_password.userInteractionEnabled=NO;
    text_password.textAlignment=UITextAlignmentCenter;
    text_password.backgroundColor=[UIColor clearColor];
    text_password.textColor=[UIColor blackColor];
    [aview addSubview:text_password];
    
    text_passwordshuru=[[UITextField alloc]initWithFrame:rect_passwordshuru];
    text_passwordshuru.backgroundColor=[UIColor lightTextColor];
    text_passwordshuru.textColor=[UIColor blackColor];
    text_passwordshuru.delegate=self;
    [aview addSubview:text_passwordshuru];


    text_passwordqueren=[[UITextField alloc]initWithFrame:rect_passwordqueren];
    text_passwordqueren.text=@"确认密码:";
    text_passwordqueren.userInteractionEnabled=NO;
    text_passwordqueren.textAlignment=UITextAlignmentCenter;
    text_passwordqueren.backgroundColor=[UIColor clearColor];
    text_passwordqueren.textColor=[UIColor blackColor];
    [aview addSubview:text_passwordqueren];
    
    text_passwordquerenshuru=[[UITextField alloc]initWithFrame:rect_passwordquerenshuru];
    text_passwordquerenshuru.backgroundColor=[UIColor lightTextColor];
    text_passwordquerenshuru.textColor=[UIColor blackColor];
    [aview addSubview:text_passwordquerenshuru];
    
    
    text_email=[[UITextField alloc]initWithFrame:rect_email];
    text_email.text=@"电子邮箱:";
    text_email.userInteractionEnabled=NO;
    text_email.backgroundColor=[UIColor clearColor];
    text_email.textColor=[UIColor blackColor];
    [aview addSubview:text_email];
    
    text_emailshuru=[[UITextField alloc]initWithFrame:rect_emailshuru];
    text_emailshuru.backgroundColor=[UIColor lightTextColor];
    text_emailshuru.textColor=[UIColor blackColor];
    text_emailshuru.delegate=self ;
    [aview addSubview:text_emailshuru];
    
    text_telephone=[[UITextField alloc]initWithFrame:rect_telephone];
    text_telephone.text=@"手机号码:";
    text_telephone.userInteractionEnabled=NO;
    text_telephone.backgroundColor=[UIColor clearColor];
    text_telephone.textColor=[UIColor blackColor];
    [aview addSubview:text_telephone];
    
    text_telephoneshuru=[[UITextField alloc]initWithFrame:rect_telephoneshuru];
    text_telephoneshuru.backgroundColor=[UIColor lightTextColor];
    text_telephoneshuru.textColor=[UIColor blackColor];
    text_telephoneshuru.delegate=self;
    [aview addSubview:text_telephoneshuru];

    



    
    UIButton *button_sender=[[UIButton alloc]initWithFrame:rect_buttonsend];
    [button_sender addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [button_sender setTitle:@"确定" forState:UIControlStateNormal];
    button_sender.tintColor=[UIColor blueColor];
    [aview addSubview:button_sender];
    


    
    
    
    
	// Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [text_emailshuru resignFirstResponder];
    [text_telephoneshuru resignFirstResponder];
    [text_usernameshuru resignFirstResponder];
    [text_passwordquerenshuru resignFirstResponder];
    [text_passwordshuru resignFirstResponder];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==text_emailshuru) {
        self.view.frame=CGRectMake(0, -30, 320, 480);
    }
    if (textField==text_telephoneshuru) {
        self.view.frame=CGRectMake(0, -100, 320, 480);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame=CGRectMake(0, 0, 320, 480);
}

-(void)send{
    if (![text_passwordshuru.text isEqualToString:text_passwordquerenshuru.text]) {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"两次输入的密码不同" message:nil delegate:self cancelButtonTitle:@"请重新输入" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else {
        NSLog(@"");
           NSError *err = nil; 
           if(![socket_register connectToHost:@"222.73.211.226" onPort:25010 error:&err]) 
          { 
               NSLog(@"连接出错");
            }else
           {
                NSLog(@"ok");
           }
    }
}


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    NSString *string_l=[NSString stringWithFormat:@"106\\%@\\%@\\%@\\%@",text_usernameshuru.text,text_passwordshuru.text,text_emailshuru.text,text_telephoneshuru.text];
    int length=string_l.length*2;
    NSString *request=[NSString stringWithFormat:@"%d\\%@",length,string_l];
    NSLog(@"request========%@",request);
    NSData *requestData = [request dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    [socket_register writeData:requestData withTimeout:1000 tag:0];
    
    NSData * separator = [@"\\" dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"separtor====%@",separator);
 
            [socket_register readDataToData:separator withTimeout:1000 tag:1];
            [socket_register readDataWithTimeout:1000 tag:2];
        
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{ 
    
    NSLog(@"tag%ld",tag);
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
    newMessage = [newMessage stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    switch (tag) {
        case 0:
            data1.messagelength=[newMessage intValue];
            
            break;
        case 1:
            data1.type=[newMessage intValue];
            break;
        case 2:
            
        {
            NSLog(@"=====================%@",newMessage);
            if ([newMessage isEqualToString:@"0"]) {
                NSLog(@"注册失败");
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alertview show];
            }
            
            else {
                NSLog(@"注册成功");
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"注册成功！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alertview show];
                //[self performSelector:@selector(fanhui) withObject:nil afterDelay:4];
            }
            
            break;
            
        }
            
        default:
            break;
    }   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   // LoginViewController *aview=[[LoginViewController alloc]init];
    [self dismissModalViewControllerAnimated:NO];
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
