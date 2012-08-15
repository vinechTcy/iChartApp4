//
//  LoginViewController.h
//  iChartApp
//
//  Created by bin huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "data.h"
#import "GCDAsyncSocket.h"
#import "Personaldetail.h"
@interface LoginViewController : UIViewController<GCDAsyncSocketDelegate,UIAlertViewDelegate>{
    GCDAsyncSocket *socket_login;
    data *data1;
    
    UIButton *uibutton;		
	UILabel *infoLabel;
	BOOL isChecked1,isChecked2;
    NSString *string_rember;
    NSString *string_arlog;
    UILabel *label_left;
    UILabel *label_rember;
    UILabel *label_arlog;
    UILabel *label_right;
    Personaldetail *userproduct;
}
@property(strong,nonatomic) NSString *stringhostlogin;
@property(strong,nonatomic) NSString *stringportlogin;
@property(nonatomic,assign) int mark_login;

@end
