//
//  HSection.h
//  chartee
//
//  Created by Tcy vinech on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYAxis.h"

@interface HSection : NSObject
{
	bool hidden;
	bool isInitialized;
	bool paging;
	int  selectedIndex;
	CGRect frame;
	float paddingLeft;
	float paddingRight;
	float paddingTop;
	float paddingBottom;
	NSMutableArray *padding;
	NSMutableArray *series;
	NSMutableArray *yAxises;
	NSMutableArray *xAxises;
}

@property(nonatomic) bool   hidden;
@property(nonatomic) bool   isInitialized;
@property(nonatomic) bool   paging;
@property(nonatomic) int    selectedIndex;
@property(nonatomic) CGRect frame;
@property(nonatomic) float  paddingLeft;
@property(nonatomic) float  paddingRight;
@property(nonatomic) float  paddingTop;
@property(nonatomic) float  paddingBottom;
@property(nonatomic,retain) NSMutableArray *padding;
@property(nonatomic,retain) NSMutableArray *series;
@property (nonatomic,retain) NSMutableArray *yAxises;
@property (nonatomic,retain) NSMutableArray *xAxises;

-(void)addYAxis:(int)pos;
-(void)removeYAxis:(int)index;
-(void)addYAxises:(int)num at:(int)pos;
-(void)removeYAxises;
-(void)initYAxises;
-(void)nextPage;
@end
