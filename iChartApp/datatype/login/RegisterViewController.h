//
//  RegisterViewController.h
//  iChartApp
//
//  Created by bin huang on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface RegisterViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,GCDAsyncSocketDelegate>{

    GCDAsyncSocket *socket_register;

    
    UITextField *text_username;
    UITextField *text_usernameshuru;
    
    UITextField *text_password;
    UITextField *text_passwordshuru;

    UITextField *text_passwordqueren;
    UITextField *text_passwordquerenshuru;
    
    UITextField *text_email;
    UITextField *text_emailshuru;
    
    UITextField *text_telephone;
    UITextField *text_telephoneshuru;

    


}

@end
