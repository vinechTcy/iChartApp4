//
//  Chart.h
//
//  Copyright 2011 vinech_Tcy. All rights reserved.
//
#define SEC_Y 120
#define SEC_X 70
#define SEC_ORIGIN_Y 20
#define SEC_ORIGIN_X 284

@protocol ChartDelegate <NSObject>
- (void)timerTitle:(int )title;
@end


#import <UIKit/UIKit.h>
#import "YAxis.h"
#import "Section.h"
#import "ChartModel.h"
#import "LineChartModel.h"
#import "AreaChartModel.h"
#import "ColumnChartModel.h"
#import "CandleChartModel.h"
#import "BarChartModel.h"
#import "CandleViewController.h"
@class ChartModel;


@interface Chart : UIView<UIPickerViewDelegate,UIPickerViewDataSource> {
    BOOL isE;
    UIButton * buttonON;
    
	bool  enableSelection;
	bool  isInitialized;
	bool  isSectionInitialized;
	float borderWidth;
	float plotWidth;
	float plotPadding;
	float plotCount;
	float paddingLeft;
	float paddingRight;
	float paddingTop;
	float paddingBottom;
	int   rangeFrom;
	int   rangeTo;
	int   range;
	int   selectedIndex;
	float touchFlag;
	float touchFlagTwo;
	NSMutableArray *padding;
	NSMutableArray *series;
	NSMutableArray *sections;
	NSMutableArray *ratios;
    NSMutableDictionary *models;
	UIColor        *borderColor;
	NSString       *title;
    //begin的时候的坐标
    CGFloat beginX;
    CGFloat movingX;
    
    NSArray * arrayTimes;
    NSArray * arrayTitle;
    UIPickerView * pick;
    UIPickerView * pick1;
    
    UIButton * yesBtn;
    UIButton * noBtn;
    UIButton * yesBtn1;
    UIButton * noBtn1;
    int   charts;
    id<ChartDelegate> delegate;
    UIButton * button;
    int seleted;
    int seleted1;
}

@property (nonatomic,strong)id<ChartDelegate>delegate;
@property (nonatomic,assign) int  timeTitle;
@property (nonatomic,assign) int   charts;

@property (nonatomic,strong) NSArray *arrayTimes;
@property (nonatomic,strong) NSArray *arrayTitle;

@property (nonatomic)        bool  enableSelection;
@property (nonatomic)        bool  isInitialized;
@property (nonatomic)        bool  isSectionInitialized;
@property (nonatomic)        float borderWidth;
@property (nonatomic)        float plotWidth;
@property (nonatomic)        float plotPadding;
@property (nonatomic)        float plotCount;
@property (nonatomic)        float paddingLeft;
@property (nonatomic)        float paddingRight;
@property (nonatomic)        float paddingTop;
@property (nonatomic)        float paddingBottom;
@property (nonatomic)        int   rangeFrom;
@property (nonatomic)        int   rangeTo;
@property (nonatomic)        int   range;
@property (nonatomic)        int   selectedIndex;
@property (nonatomic)        float touchFlag;
@property (nonatomic)        float touchFlagTwo;
@property (nonatomic,strong) NSMutableArray *padding;
@property (nonatomic,strong) NSMutableArray *series;
@property (nonatomic,strong) NSMutableArray *sections;
@property (nonatomic,strong) NSMutableArray  *ratios;
@property (nonatomic,strong) NSMutableDictionary *models;
@property (nonatomic,strong) UIColor  *borderColor;
@property (nonatomic,strong) NSString *title;

-(float)getLocalY:(float)val withSection:(int)sectionIndex withAxis:(int)yAxisIndex;
-(void)setSelectedIndexByPoint:(CGPoint) point;
-(void)reset;
- (void)setDelegate:(id<ChartDelegate>)theDelegate;

/* init */
-(void)initChart;
-(void)initXAxis;
-(void)initYAxis;
-(void)initModels;
-(void)addModel:(ChartModel *)model withName:(NSString *)name;
-(ChartModel *)getModel:(NSString *)name;

/* draw */
-(void)drawChart;
-(void)drawXAxis;
-(void)drawYAxis;
-(void)drawSerie:(NSMutableDictionary *)serie;
-(void)drawLabels;
-(void)setLabel:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie;

/* data */
-(void)appendToData:(NSArray *)data forName:(NSString *)name;
-(void)clearDataforName:(NSString *)name;
-(void)clearData;
-(void)setData:(NSMutableArray *)data forName:(NSString *)name;

/* category */
-(void)appendToCategory:(NSArray *)category forName:(NSString *)name;
-(void)clearCategoryforName:(NSString *)name;
-(void)clearCategory;
-(void)setCategory:(NSMutableArray *)category forName:(NSString *)name;

/* series */
-(NSMutableDictionary *)getSerie:(NSString *)name;
-(void)addSerie:(NSObject *)serie;

/* section */
-(Section *)getSection:(int) index;
-(int) getIndexOfSection:(CGPoint) point;
-(void)addSection:(NSString *)ratio;
-(void)removeSection:(int)index;
-(void)addSections:(int)num withRatios:(NSArray *)rats;
-(void)removeSections;
-(void)initSections;

/* YAxis */
-(YAxis *)getYAxis:(int) section withIndex:(int) index;
-(void)setValuesForYAxis:(NSDictionary *)serie;

@end
