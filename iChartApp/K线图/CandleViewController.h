//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Chart.h"
#import "YAxis.h"

#import "HChart.h"
#import "HYAxis.h"

#import "AutoCompleteDelegate.h"

#import "MBProgressHUD.h"
#import "GCDAsyncSocket.h"
#import "data.h"
#import "data2.h"

@interface CandleViewController : UIViewController<UISearchBarDelegate,UIAlertViewDelegate,ChartDelegate,HChartDelegate,MBProgressHUDDelegate> {
    UILabel * label;
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    
	
    Chart *candleChart;
    Chart *hcandleChart;
    
	UITableView *autoCompleteView;
    
    NSTimer *timer;
    
	UIView *toolBar;
	UIView *candleChartFreqView;
    UIView * viewNavgation;
    UIView * backgroundViews;
    
	AutoCompleteDelegate *autoCompleteDelegate;
	
	
    UILabel *security;
	UILabel *status;
	
    int tradeStatus;
	int chartMode;
    int result;
    int count;
	
    NSString *lastTime;
	NSString *req_freq;
	NSString *req_type;
	NSString *req_url;
	NSString *req_security_id;
    NSString *sessionID;
    NSString *newMessage;
    NSString*requestLength;
    NSString *request1;
    NSString *string_yanse;//接收是否是暗黑状态
    // NSString *string_color;//判断是否是暗黑状态
    
    
    
    GCDAsyncSocket *socket1;
    NSUserDefaults * user;
    
    data *data1;
    data2 *_data2;
    
    UIActivityIndicatorView *activity;
    
    NSData *requestData1;
    
    UISegmentedControl * seg;
    
    MBProgressHUD *HUD;
    
    NSMutableArray *datas;
    
    BOOL HUDTime;
    BOOL upView;
    int background_views_width;
    int background_views_height;
}
@property(nonatomic,assign) int biaoji;//由首页推过来的时候的tableview的indexpath.row
@property(strong,nonatomic)NSMutableArray *array_pro;//用来接收由首页传过来的所有产品的名字

@property (nonatomic,strong)  UIView *viewHUB;//大背景
@property (nonatomic,strong)  UIView *viewBack;//小背景（放菊花用的）
@property (nonatomic,strong) UIActivityIndicatorView *activity;//小菊花
@property (nonatomic,strong)  UIImageView *imageBack;//X子的view
@property (nonatomic,strong)  UIButton *backButton;//点击X退回上个界面

@property (nonatomic,assign)  int Minute;//周期时间
@property (nonatomic,strong)  NSString *codeName;//产品名称
@property (nonatomic,strong)  NSString *userName;//用户名
@property (nonatomic,strong)  NSString *passWord;//密码
//@property (nonatomic,strong)  NSString *string_yanse;//密码
@property (nonatomic,strong)  NSString *string_color;//密码


//*******************菊花&背景*X子&小背景*************************************

@property (nonatomic,assign) int BACKBUTTON_FRAME_HEIGHT;
@property (nonatomic,assign) int BACKBUTTON_FRAME_WIDTH;
@property (nonatomic,assign) int BACKBUTTON_FRAME_Y;
@property (nonatomic,assign) int BACKBUTTON_FRAME_X;

@property (nonatomic,assign) int LABELDATA_FRAME_X;
@property (nonatomic,assign) int LABELDATA_FRAME_Y;
@property (nonatomic,assign) int LABELDATA_FRAME_WIDTH;
@property (nonatomic,assign) int LABELDATA_FRAME_HEIGHT;

@property (nonatomic,assign) int VIEWBACK_FRAME_X;
@property (nonatomic,assign) int VIEWBACK_FRAME_Y;
@property (nonatomic,assign) int VIEWBACK_FRAME_WIDTH;
@property (nonatomic,assign) int VIEWBACK_FRAME_HEIGHT;

@property (nonatomic,assign) int SELF_VIEW_FRAME_X ;
@property (nonatomic,assign) int SELF_VIEW_FRAME_Y ;
@property (nonatomic,assign) int SELF_VIEW_FRAME_WIDTH ;
@property (nonatomic,assign) int SELF_VIEW_FRAME_HEIGHT;

@property (nonatomic,assign) int SELF_CANDLECHART_FRAME_X;
@property (nonatomic,assign) int SELF_CANDLECHART_FRAME_Y;
@property (nonatomic,assign) int SELF_CANDLECHART_FRAME_WIDTH;
@property (nonatomic,assign) int SELF_CANDLECHART_FRAME_HEIGHT;

@property (nonatomic,assign) int SELF_ACTIVITY_FRAME_X;
@property (nonatomic,assign) int SELF_ACTIVITY_FRAME_Y;
@property (nonatomic,assign) int SELF_ACTIVITY_FRAME_WIDTH;
@property (nonatomic,assign) int SELF_ACTIVITY_FRAME_HEIGHT;

@property (nonatomic,assign) int VIEWHUB_FRAME_X;
@property (nonatomic,assign) int VIEWHUB_FRAME_Y;
@property (nonatomic,assign) int VIEWHUB_FRAME_WIDTH;
@property (nonatomic,assign) int VIEWHUB_FRAME_HEIGHT;

//**************************************************************************



//********************初始化横竖屏********************************************

@property (nonatomic,strong) Chart *candleChart;//竖屏
@property (nonatomic,strong) Chart *hcandleChart;//横屏

//**************************************************************************




@property (nonatomic,strong) UITableView *autoCompleteView;
@property (nonatomic,strong) UIView *toolBar;
@property (nonatomic,strong) UIView *candleChartFreqView;
@property (nonatomic,strong) AutoCompleteDelegate *autoCompleteDelegate;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int chartMode;
@property (nonatomic,assign) int tradeStatus;
@property (nonatomic,strong) NSString *lastTime;
@property (nonatomic,strong) UILabel *status;
@property (nonatomic,strong) NSString *req_freq;
@property (nonatomic,strong) NSString *req_type;
@property (nonatomic,strong) NSString *req_url;
@property (nonatomic,strong) NSString *req_security_id;
@property (nonatomic,strong) NSMutableArray * arrTitle;
@property (nonatomic,assign) BOOL arrayEdit;
@property (nonatomic,strong) NSMutableArray * arrValue;
@property (strong,nonatomic) NSString *stringhost;
@property (strong,nonatomic) NSString *stringport;

-(void)initChart;

-(void)getData;

-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data;

-(void)setData:(NSDictionary *)dic;

-(void)setCategory:(NSArray *)category;

-(BOOL)isCodesExpired;

-(void)getAutoCompleteData;

-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie;

@end
