//
//  AppDelegate.h
//  iChartApp
//
//  Created by bin huang on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//n时llllllln

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    GCDAsyncSocket *_socket;
}

@property (strong, nonatomic) UIWindow *window;

@end
