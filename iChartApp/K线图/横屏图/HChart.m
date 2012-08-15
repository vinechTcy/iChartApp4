//
//  HChart.m
//  chartee
//
//  Created by Tcy vinech on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HChart.h"

@implementation HChart

#define MIN_INTERVAL  1

@synthesize enableSelection; 
@synthesize isInitialized;
@synthesize isSectionInitialized;
@synthesize borderColor;
@synthesize borderWidth;
@synthesize plotWidth;
@synthesize plotPadding;
@synthesize plotCount;
@synthesize paddingLeft;
@synthesize paddingRight;
@synthesize paddingTop;
@synthesize paddingBottom;
@synthesize padding;
@synthesize selectedIndex;
@synthesize touchFlag;
@synthesize touchFlagTwo;
@synthesize rangeFrom;
@synthesize rangeTo;
@synthesize range;
@synthesize series;
@synthesize sections;
@synthesize ratios;
@synthesize models;
@synthesize title;

@synthesize arrayTimes;
@synthesize arrayTitle;
@synthesize timeTitle;
@synthesize charts;
@synthesize delegate;

-(float)getLocalY:(float)val withSection:(int)sectionIndex withAxis:(int)yAxisIndex{
	HSection *sec = [[self sections] objectAtIndex:sectionIndex];
	HYAxis *yaxis = [sec.yAxises objectAtIndex:yAxisIndex];
	CGRect fra = sec.frame;
	float  max = yaxis.max;
	float  min = yaxis.min;
    return fra.size.height - (fra.size.height-sec.paddingTop)* (val-min)/(max-min)+fra.origin.y;
}

- (void)initChart{
	if(!self.isInitialized){
		self.plotPadding = 1.f;
		if(self.padding != nil){
			self.paddingTop    = [[self.padding objectAtIndex:0] floatValue];
			self.paddingRight  = [[self.padding objectAtIndex:1] floatValue];
			self.paddingBottom = [[self.padding objectAtIndex:2] floatValue];
			self.paddingLeft   = [[self.padding objectAtIndex:3] floatValue];
		}
		
		if(self.series!=nil){
			self.rangeTo = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
			if(rangeTo-range >= 0){
				self.rangeFrom = rangeTo-range;
			}else{
			    self.rangeFrom = 0;
			}
		}else{
			self.rangeTo   = 0;
			self.rangeFrom = 0;
		}
		self.selectedIndex = self.rangeTo-1;
		self.isInitialized = YES;
	}
    
	if(self.series!=nil){
		self.plotCount = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
	}
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //背景填充颜色
    CGContextSetRGBFillColor(context, 0/255.0f, 0/255.0f, 0/255.0f, 1.0); 
    CGContextFillRect (context, CGRectMake (0, 0, self.bounds.size.width,self.bounds.size.height)); 
}

-(void)reset{
	self.isInitialized = NO;
}

- (void)initXAxis{
    
}

- (void)initYAxis{
    
	for(int secIndex=0;secIndex<[self.sections count];secIndex++){
		HSection *sec = [self.sections objectAtIndex:secIndex];
		for(int sIndex=0;sIndex<[sec.yAxises count];sIndex++){
			HYAxis *yaxis = [sec.yAxises objectAtIndex:sIndex];
			yaxis.isUsed = NO;
		}
	}
	
	for(int secIndex=0;secIndex<[self.sections count];secIndex++){
		HSection *sec = [self.sections objectAtIndex:secIndex];
		if(sec.paging){
			NSObject *serie = [[sec series] objectAtIndex:sec.selectedIndex];
            NSArray *seri=(NSArray *)serie;
            
			if([serie isKindOfClass:[NSArray class]]){
				for(int i=0;i<[seri count];i++){
					[self setValuesForYAxis:[seri objectAtIndex:i]];
				}
			}else {
				[self setValuesForYAxis:(NSMutableDictionary *)seri];
			}
		}else{
			for(int sIndex=0;sIndex<[sec.series count];sIndex++){
				NSObject *serie = [[sec series] objectAtIndex:sIndex];
                NSArray *seri=(NSArray *)serie;
                
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[seri count];i++){
						[self setValuesForYAxis:[seri objectAtIndex:i]];
					}
				}else {
					[self setValuesForYAxis:(NSMutableDictionary *)seri];
				}
			}
		}
		
		for(int i = 0;i<sec.yAxises.count;i++){
			HYAxis *yaxis = [sec.yAxises objectAtIndex:i];
			yaxis.max += (yaxis.max-yaxis.min)*yaxis.ext;
			yaxis.min -= (yaxis.max-yaxis.min)*yaxis.ext;
			
			if(!yaxis.baseValueSticky){
				if(yaxis.max >= 0 && yaxis.min >= 0){
					yaxis.baseValue = yaxis.min;
				}else if(yaxis.max < 0 && yaxis.min < 0){
					yaxis.baseValue = yaxis.max;
				}else{
					yaxis.baseValue = 0;
				}
			}else{
				if(yaxis.baseValue < yaxis.min){
					yaxis.min = yaxis.baseValue;
				}
				
				if(yaxis.baseValue > yaxis.max){
					yaxis.max = yaxis.baseValue;
				}
			}
			
			if(yaxis.symmetrical == YES){
				if(yaxis.baseValue > yaxis.max){
					yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
				}else if(yaxis.baseValue < yaxis.min){
					yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
				}else {
					if((yaxis.max-yaxis.baseValue) > (yaxis.baseValue-yaxis.min)){
						yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
					}else{
						yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
					}
				}
			}	
		}
	}
}

-(void)setValuesForYAxis:(NSDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    HChartModel *model = [self getModel:type];
    [model setValuesForYAxis:self serie:serie];	
}

-(void)drawChart{
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		HSection *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
		    continue;
		}
		plotWidth = (sec.frame.size.width-sec.paddingLeft)/(self.rangeTo-self.rangeFrom);
		for(int sIndex=0;sIndex<sec.series.count;sIndex++){
			NSObject *serie = [sec.series objectAtIndex:sIndex];
			NSArray *seri=(NSArray *)serie;
			if(sec.hidden){
				continue;
			}
			
			if(sec.paging){
				if (sec.selectedIndex == sIndex) {
					if([serie isKindOfClass:[NSArray class]]){
						for(int i=0;i<[seri count];i++){
							[self drawSerie:[seri objectAtIndex:i]];
						}
					}else{
						[self drawSerie:(NSMutableDictionary *)seri];
					}
					break;
				}
			}else{
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[seri count];i++){
						[self drawSerie:[seri objectAtIndex:i]];
					}
				}else{
					[self drawSerie:(NSMutableDictionary *)seri];
				}
			}			
		}
	}	
	[self drawLabels];
}
//nima lebi  de schou shabi 

-(void)drawLabels{
    
	for(int i=0;i<self.sections.count;i++){
		HSection *sec = [self.sections objectAtIndex:i];
		if(sec.hidden){
		    continue;
		}
		
		float w = 0;
		for(int s=0;s<sec.series.count;s++){
			NSMutableArray *label =[[NSMutableArray alloc] init];
		    NSObject *serie = [sec.series objectAtIndex:s];
            NSArray *seri=(NSArray *)serie;
            
			if(sec.paging){
				if (sec.selectedIndex == s) {
					if([serie isKindOfClass:[NSArray class]]){
						for(int i=0;i<[seri count];i++){
							[self setLabel:label forSerie:[seri objectAtIndex:i]];
						}
					}else{
						[self setLabel:label forSerie:(NSMutableDictionary *)serie];
					}
				}
			}else{
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[seri count];i++){
						[self setLabel:label forSerie:[seri objectAtIndex:i]];
					}
				}else{
					[self setLabel:label forSerie:(NSMutableDictionary *)seri];
				}
			}
            //   NSLog(@"%@",label);
			for(int j=0;j<label.count;j++){
				NSMutableDictionary *lbl = [label objectAtIndex:j];
				NSString *text  = [lbl objectForKey:@"text"];
				NSString *color = [lbl objectForKey:@"color"];
				NSArray *colors = [color componentsSeparatedByString:@","];
				CGContextRef context = UIGraphicsGetCurrentContext();
				CGContextSetShouldAntialias(context, YES);
				CGContextSetRGBFillColor(context, [[colors objectAtIndex:0] floatValue], [[colors objectAtIndex:1] floatValue], [[colors objectAtIndex:2] floatValue], 1.0);
                //                NSLog(@"sec.frame.size.width = %f",sec.frame.size.width);
                if (sec.frame.origin.x+sec.paddingLeft+2+w < sec.frame.size.width+20 && sec.frame.origin.y<119.5) {
                    
                    [text drawAtPoint:CGPointMake(sec.frame.origin.x+sec.paddingLeft+2+w,sec.frame.origin.y-20) withFont:[UIFont systemFontOfSize: 12]];
                    
                }
                else {
                    
                    [text drawAtPoint:CGPointMake(sec.frame.origin.x-284+sec.paddingLeft+2+w,sec.frame.origin.y-5) withFont:[UIFont systemFontOfSize: 12]];
                    
                }
                // NSLog(@"X游标 高度 %f",sec.frame.origin.y);
                if (sec.frame.origin.y>=119.5) {
                    [text drawAtPoint:CGPointMake(sec.frame.origin.x+sec.paddingLeft+2+w,sec.frame.origin.y+5) withFont:[UIFont systemFontOfSize: 12]];
                    
                }
                
				w += [text sizeWithFont:[UIFont systemFontOfSize:12.5]].width;
			}
		}
	}
}

-(void)setLabel:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
	NSString   *type  = [serie objectForKey:@"type"];
    HChartModel *model = [self getModel:type];
    [model setLabel:self label:label forSerie:serie];		
}

-(void)drawSerie:(NSMutableDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    HChartModel *model = [self getModel:type];
    [model drawSerie:self serie:serie];	
    
    NSEnumerator *enumerator = [self.models keyEnumerator];  
    id key;  
    while ((key = [enumerator nextObject])){  
        HChartModel *m = [self.models objectForKey:key];
        [m drawTips:self serie:serie];
    }
}
//游标Y
-(void)drawYAxis{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO );
	CGContextSetLineWidth(context, 1.0f);
	
	for(int secIndex=0;secIndex<[self.sections count];secIndex++){
		HSection *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
		CGContextMoveToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
		CGContextStrokePath(context);
	}
	
    //游标的颜色
	CGContextSetRGBFillColor(context, 255/255.f, 255/255.f, 255/255.f, 1.0);
	CGFloat dash[] = {5};
	CGContextSetLineDash (context,0,dash,1);  
    
	for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		HSection *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		for(int aIndex=0;aIndex<sec.yAxises.count;aIndex++){
			HYAxis *yaxis = [sec.yAxises objectAtIndex:aIndex];
			NSString *format=[@"%." stringByAppendingFormat:@"%df",5];//yaxis.decimal
			float baseY = [self getLocalY:yaxis.baseValue withSection:secIndex withAxis:aIndex];
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
            //            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:64/255.0f green:0 blue:79/255.0f alpha:1.0].CGColor);
            
			CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
			CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,baseY);
			CGContextStrokePath(context);
			
            //游标最后一个字段
			[[@"" stringByAppendingFormat:format,yaxis.baseValue] drawAtPoint:CGPointMake(sec.frame.origin.x-1,baseY-7) withFont:[UIFont systemFontOfSize: 11]];
			
			CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0].CGColor);
			CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
			CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,baseY);
            
			if (yaxis.tickInterval%2 == 1) {
				yaxis.tickInterval +=1;
			}
			
			float step = (float)(yaxis.max-yaxis.min)/yaxis.tickInterval;
			for(int i=1; i<= yaxis.tickInterval+1;i++){
				if(yaxis.baseValue + i*step <= yaxis.max){
					float iy = [self getLocalY:(yaxis.baseValue + i*step) withSection:secIndex withAxis:aIndex];
					
					CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
					CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
					CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
					CGContextStrokePath(context);
					
					[[@"" stringByAppendingFormat:format,yaxis.baseValue+i*step] drawAtPoint:CGPointMake(sec.frame.origin.x-1,iy-7) withFont:[UIFont systemFontOfSize: 11]];
					
					if(yaxis.baseValue + i*step < yaxis.max){
						CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0].CGColor);
						CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
						CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
					}
					
					CGContextStrokePath(context);
				}
			}
			for(int i=1; i <= yaxis.tickInterval+1;i++){
				if(yaxis.baseValue - i*step >= yaxis.min){
					float iy = [self getLocalY:(yaxis.baseValue - i*step) withSection:secIndex withAxis:aIndex];
					
					CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
					CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy-10);
					CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
					CGContextStrokePath(context);
					
					[[@"" stringByAppendingFormat:format,yaxis.baseValue-i*step] drawAtPoint:CGPointMake(sec.frame.origin.x-1,iy-7) withFont:[UIFont systemFontOfSize: 12]];
					
					if(yaxis.baseValue - i*step > yaxis.min){
						CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0].CGColor);
						CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
						CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
					}
					
					CGContextStrokePath(context);
				}
			}
		}
	}	
	CGContextSetLineDash (context,0,NULL,0); 
}

//***************//***************//***************//***************//***************

//***************//***************//***************//***************//***************//***************//***************//***************//***************
-(void)drawXAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 1.0f);
    //边线的颜色
    CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
	//CGContextSetStrokeColorWithColor(context,[[UIColor alloc] initWithRed:180/255.0f green:147/255.0f blue:0/255.0f alpha:1.0].CGColor);
    //[[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
	for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		HSection *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
		
		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
	}
	CGContextStrokePath(context);
}

-(void) setSelectedIndexByPoint:(CGPoint) point{
	
	if([self getIndexOfSection:point] == -1){
		return;
	}
	HSection *sec = [self.sections objectAtIndex:[self getIndexOfSection:point]];
	
	for(int i=self.rangeFrom;i<self.rangeTo;i++){
        //        NSLog(@"______________range----%d------%d",self.rangeFrom,self.rangeTo);
        if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<plotWidth*((i-self.rangeFrom)+1)){
			if (self.selectedIndex != i) {
				self.selectedIndex=i;
				[self setNeedsDisplay];
			}
			
			return;
		}
	}
}

-(void)appendToData:(NSArray *)data forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"data"] == nil){
				NSMutableArray *tempData = [[NSMutableArray alloc] init];
			    [[self.series objectAtIndex:i] setObject:tempData forKey:@"data"];
			}
			
			for(int j=0;j<data.count;j++){
				[[[self.series objectAtIndex:i] objectForKey:@"data"] addObject:[data objectAtIndex:j]];
			}
	    }
	}
}

-(void)clearDataforName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"data"] != nil){
				[[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
			}
	    }
	}
}

-(void)clearData{
	for(int i=0;i<self.series.count;i++){
		[[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
	}
}

-(void)setData:(NSMutableArray *)data forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
		    [[self.series objectAtIndex:i] setObject:data forKey:@"data"];
		}
	}
}

-(void)appendToCategory:(NSArray *)category forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"category"] == nil){
				NSMutableArray *tempData = [[NSMutableArray alloc] init];
			    [[self.series objectAtIndex:i] setObject:tempData forKey:@"category"];
			}
			
			for(int j=0;j<category.count;j++){
				[[[self.series objectAtIndex:i] objectForKey:@"category"] addObject:[category objectAtIndex:j]];
			}
	    }
	}
}

-(void)clearCategoryforName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqual:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"category"] != nil){
				[[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
			}
	    }
	}
}

-(void)clearCategory{
	for(int i=0;i<self.series.count;i++){
		[[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
	}
}

-(void)setCategory:(NSMutableArray *)category forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
		    [[self.series objectAtIndex:i] setObject:category forKey:@"category"];
		}
	}
}

/*
 * Sections
 */
-(HSection *)getSection:(int) index{
    return [self.sections objectAtIndex:index];
}
-(int)getIndexOfSection:(CGPoint) point{
    for(int i=0;i<self.sections.count;i++){
	    HSection *sec = [self.sections objectAtIndex:i];
		if (CGRectContainsPoint(sec.frame, point)){
		    return i;
		}
	}
	return -1;
}

/*
 * series
 */
-(NSMutableDictionary *)getSerie:(NSString *)name{
	NSMutableDictionary *serie = nil;
    for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			serie = [self.series objectAtIndex:i];
			break;
		}
	}
	return serie;
}

-(void)addSerie:(NSObject *)serie{
    NSDictionary *seri=(NSDictionary *)serie;
    
	if([serie isKindOfClass:[NSArray class]]){
		int section = 0;
	    for (NSDictionary *ser in seri) {
		    section = [[ser objectForKey:@"section"] intValue];
			[self.series addObject:ser];
		}
		[[[self.sections objectAtIndex:section] series] addObject:serie];
	}else{
        
		int section =[[seri objectForKey:@"section"] intValue];
		[self.series addObject:serie];
		[[[self.sections objectAtIndex:section] series] addObject:serie];
	}
}

/*
 *  Chart Sections
 */ 
-(void)addSection:(NSString *)ratio{
	[ratio retain];
	HSection *sec = [[HSection alloc] init];
    [self.sections addObject:sec];
	[self.ratios addObject:ratio];
}

-(void)removeSection:(int)index{
    [self.sections removeObjectAtIndex:index];
	[self.ratios removeObjectAtIndex:index];
}

-(void)addSections:(int)num withRatios:(NSArray *)rats{
	[rats retain];
	for (int i=0; i< num; i++) {
		HSection *sec = [[HSection alloc] init];
		[self.sections addObject:sec];
		[self.ratios addObject:[rats objectAtIndex:i]];
	}
}

-(void)removeSections{
    [self.sections removeAllObjects];
	[self.ratios removeAllObjects];
}

-(void)initSections{
    float height = self.frame.size.height-(self.paddingTop+self.paddingBottom);
    float width  = self.frame.size.width-(self.paddingLeft+self.paddingRight);
    
    int total = 0;
    for (int i=0; i< self.ratios.count; i++) {
        if([[self.sections objectAtIndex:i] hidden]){
            continue;
        }
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        total+=ratio;
    }
    
    HSection*prevSec = nil;
    for (int i=0; i< self.sections.count; i++) {
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        HSection *sec = [self.sections objectAtIndex:i];
        if([sec hidden]){
            continue;
        }
        float h = height*ratio/total;
        float w = width;
        
        if(i==0){
            [sec setFrame:CGRectMake(0+self.paddingLeft, 0+self.paddingTop, w,h)];
        }else{
            if(i==([self.sections count]-1)){
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,self.paddingTop+height-(prevSec.frame.origin.y+prevSec.frame.size.height))];
            }else {
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,h)];
            }
        }
        prevSec = sec;
        
    }
    self.isSectionInitialized = YES;
}


-(HYAxis *)getYAxis:(int) section withIndex:(int) index{
	HSection *sec = [self.sections objectAtIndex:section];
	HYAxis *yaxis = [sec.yAxises objectAtIndex:index];
    return yaxis;
}

/* 
 * UIView Methods
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		self.enableSelection = YES;
		self.isInitialized   = NO;
		self.isSectionInitialized   = NO;
		self.selectedIndex   = -1;
		self.padding         = nil;
		self.paddingTop      = 0;
		self.paddingRight    = 0;
		self.paddingBottom   = 0;
		self.paddingLeft     = 0;
		self.rangeFrom       = 0;
		self.rangeTo         = 0;
		self.range           = 30;//上来显示的蜡烛根数
		self.touchFlag       = 0;
		self.touchFlagTwo    = 0;
        self.timeTitle       = 1440;
        self.charts          = 0;
        seleted              = 0;
        seleted1             = 0;
		NSMutableArray *rats = [[NSMutableArray alloc] init];
		self.ratios          = rats; 
		
		NSMutableArray *secs = [[NSMutableArray alloc] init];
		self.sections        = secs; 
        
        NSMutableDictionary *mods = [[NSMutableDictionary alloc] init];
		self.models        = mods; 
		
		[self setMultipleTouchEnabled:YES];
        
        
        
        
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(16, 2, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        //init models
        [self initModels];
    } 
    return self;
}

#pragma mark - Choose Button
- (void)choose
{
    isE = !isE;    
    // NSArray * array = [[NSArray alloc] initWithObjects:@"图表模式",@"技术指标",@"最大化",@"周期", nil];
    NSArray * arrayimg = [[NSArray alloc] initWithObjects:@"periodBtn.png",@"chartMode.png",@"TIBtn.png",nil];
    
    UIImageView *backgroundView =[[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 120, 120)];
    backgroundView.image = [UIImage imageNamed:@"backImage.png"];
    backgroundView.tag = 66;
    backgroundView.userInteractionEnabled =YES;
    [self addSubview:backgroundView];
    
    
    if (isE == 1) {
        for (int i =0; i<3; i++) {
            buttonON = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            buttonON.frame =CGRectMake(0,4+i*40, 120,40);
            buttonON.tag = i+100;
            [buttonON setBackgroundImage:[UIImage imageNamed:[arrayimg objectAtIndex:i]] forState:UIControlStateNormal];
            
            // [buttonON setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [buttonON addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [backgroundView addSubview:buttonON];
        } 
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
        
        
        for (int i = 100; i<103;i++) {
            UIButton * btn  = (UIButton *)[self viewWithTag:i];
            [btn removeFromSuperview];
            UIImageView *imageV = (UIImageView *)[self viewWithTag:66];
            [imageV removeFromSuperview];
        }
    }
}

#pragma mark - Choose Button -1
- (void)buttonTap:(UIButton *)sender
{
    
    switch (sender.tag) {
            
        case 100:
        {
            
            arrayTimes = [[NSArray alloc] initWithObjects:@"1 Minute (m1)",@"5 Minutes (m5)",@"15 Minutes (m15)",@"30 Minutes (m30)",@"1 Hour (H1)",@"1 Day (D1)",@"1 Week (W1)",@"1 Month (M1)",nil];
            
            arrayTitle = [[NSArray alloc] initWithObjects:@"1",@"5",@"15",@"30",@"60",@"1440",@"10080",@"43200",nil];
            seleted1 = 0;
            if (seleted == 0) {
                seleted++;
                
                yesBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                yesBtn1.frame = CGRectMake(self.frame.size.width-110, 240, 30, 30);
                yesBtn1.tag = 1002;
                [yesBtn1 setBackgroundImage:[UIImage imageNamed:@"savebtn.png"] forState:UIControlStateNormal];
                // [yesBtn1 setTitle:@"YES" forState:UIControlStateNormal];
                [yesBtn1 addTarget:self action:@selector(reBtn:)forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:yesBtn1];
                
                noBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                noBtn1.frame = CGRectMake(self.frame.size.width-50, 240, 30, 30);
                noBtn1.tag = 1003;
                [noBtn1 setBackgroundImage:[UIImage imageNamed:@"cloesbtn.png"] forState:UIControlStateNormal];
                // [noBtn1 setTitle:@"NO" forState:UIControlStateNormal];
                [noBtn1 addTarget:self action:@selector(reBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:noBtn1];
                
                
                pick1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0,self.frame.size.height/2,self.frame.size.width,self.frame.size.height/2-70)];
                pick1.dataSource = self;
                pick1.delegate = self;
                pick1.tag =20;
                [pick selectRow:2 inComponent:0 animated:YES];
                pick1.showsSelectionIndicator = YES;
                [self addSubview:pick1];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.2f];
                yesBtn1.frame = CGRectMake(self.frame.size.width-110, 50, 30, 30);
                noBtn1.frame  = CGRectMake(self.frame.size.width-50, 50, 30, 30);
                pick1.frame   = CGRectMake(0, 80, self.frame.size.width, self.frame.size.height/2-90);
                
                pick.frame    = CGRectMake(0, 240, self.frame.size.width, 160);
                yesBtn.frame  = CGRectMake(self.frame.size.width-110, 240, 30, 30);
                noBtn.frame   = CGRectMake(self.frame.size.width-50, 240, 30, 30);
                
                [UIView commitAnimations];
                
                for (int i = 100; i<104;i++) {
                    UIButton * btn  = (UIButton *)[self viewWithTag:i];
                    [btn removeFromSuperview ];
                }
                
                [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
                
                UIImageView *imageV = (UIImageView *)[self viewWithTag:66];
                
                [imageV removeFromSuperview];
                
                isE=0;
                
            }else {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"已经打开周期选项" message:@"请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                
                for (int i = 100; i<103;i++) {
                    UIButton * btn  = (UIButton *)[self viewWithTag:i];
                    [btn removeFromSuperview ];
                }
                
                [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
                
                UIImageView *imageV = (UIImageView *)[self viewWithTag:66];
                
                [imageV removeFromSuperview];
                
                isE=0;
            }
        }
            break;
        case 101:
        {
            seleted = 0;
            if (seleted1 == 0) {
                seleted1++;
                
                yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                yesBtn.frame = CGRectMake(self.frame.size.width-110, 240, 30, 30);
                yesBtn.tag = 1000;
                [yesBtn setBackgroundImage:[UIImage imageNamed:@"savebtn.png"] forState:UIControlStateNormal];
                //            [yesBtn setTitle:@"YES" forState:UIControlStateNormal];
                [yesBtn addTarget:self action:@selector(reBtn:)forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:yesBtn];
                
                noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                noBtn.frame = CGRectMake(self.frame.size.width-50, 240, 30, 30);
                noBtn.tag = 1001;
                [noBtn setBackgroundImage:[UIImage imageNamed:@"cloesbtn.png"] forState:UIControlStateNormal];
                //            [noBtn setTitle:@"NO" forState:UIControlStateNormal];
                [noBtn addTarget:self action:@selector(reBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:noBtn];
                
                pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 240,self.frame.size.width,150)];
                pick.dataSource = self;
                pick.delegate = self;
                pick.tag =10;
                [pick selectRow:5 inComponent:0 animated:YES];
                pick.showsSelectionIndicator = YES;
                [self addSubview:pick];
                arrayTimes = [[NSArray alloc] initWithObjects:@"蜡烛图",@"面积图",@"柱形图",@"线型图",@"美国图",nil];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.2f];
                yesBtn.frame  = CGRectMake(self.frame.size.width-110, 50, 30, 30);
                noBtn.frame   = CGRectMake(self.frame.size.width-50 , 50, 30, 30);
                pick.frame    = CGRectMake(0, 80, self.frame.size.width, 160);
                
                yesBtn1.frame = CGRectMake(self.frame.size.width-110, 240, 30, 30);
                noBtn1.frame  = CGRectMake(self.frame.size.width-50 , 240, 30, 30);
                pick1.frame   = CGRectMake(0, 240, self.frame.size.width, 160);
                [UIView commitAnimations];
                
                
                for (int i = 100; i<104;i++) {
                    UIButton * btn  = (UIButton *)[self viewWithTag:i];
                    [btn removeFromSuperview ];
                    
                }
                
                [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
                
                UIImageView *imageV = (UIImageView *)[self viewWithTag:66];
                
                [imageV removeFromSuperview];
                
                isE=0;
                
            }else {
                
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"已经打开图标模式选项" message:@"请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                
                for (int i = 100; i<103;i++) {
                    UIButton * btn  = (UIButton *)[self viewWithTag:i];
                    [btn removeFromSuperview ];
                }
                
                [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
                
                UIImageView *imageV = (UIImageView *)[self viewWithTag:66];
                
                [imageV removeFromSuperview];
                
                isE=0;
            }
        }
            break;  
            
        case 102:
        {
            
            
            
            
            UIImageView *imageV = (UIImageView *)[self viewWithTag:66];
            
            [imageV removeFromSuperview];
            
            [button setBackgroundImage:[UIImage imageNamed:@"unClickBtn.png"] forState:UIControlStateNormal];
            
            for (int i = 100; i<104;i++) {
                UIButton * btn  = (UIButton *)[self viewWithTag:i];
                [btn removeFromSuperview ];
            }
            
            isE=0;
            
        }
            break;
            
        default:
            break;
            
    }
}

#pragma mark - button YES OR NO
- (void)reBtn:(UIButton *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    yesBtn.frame  = CGRectMake(self.frame.size.width-90, 240, 30, 30);
    noBtn.frame   = CGRectMake(self.frame.size.width-50, 240, 30, 30);
    
    yesBtn1.frame = CGRectMake(self.frame.size.width-90, 240, 30, 30);
    noBtn1.frame  = CGRectMake(self.frame.size.width-50, 240, 30, 30);
    pick.frame    = CGRectMake(0, 240, self.frame.size.width, 162);
    pick1.frame   = CGRectMake(0, 240, self.frame.size.width, 162);
    seleted              = 0;
    seleted1             = 0;
    
    [UIView commitAnimations];
    
    switch (sender.tag) {
        case 1000:
        {
            
            HChartModel *model = [[HLineChartModel alloc] init];
            switch (charts) {
                case 0:
                {
                    model = [[HCandleChartModel alloc] init];
                    [self addModel:model withName:@"candle"];
                    [self setNeedsDisplay];
                    
                }
                    break;
                case 1:
                {
                    model = [[HAreaChartModel alloc] init];
                    
                    [self addModel:model withName:@"candle"];
                    [self setNeedsDisplay];
                    
                }
                    break;
                case 2:
                {
                    model = [[HColumnChartModel alloc] init];
                    [self addModel:model withName:@"candle"];
                    
                    [self setNeedsDisplay];
                    
                }
                    break;
                case 3:
                {
                    model = [[HLineChartModel  alloc] init];
                    [self addModel:model withName:@"candle"];
                    
                    [self setNeedsDisplay];
                    
                }
                    break;
                case 4:
                {
                    model = [[HBarChartModel  alloc] init];
                    [self addModel:model withName:@"candle"];
                    
                    [self setNeedsDisplay];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1001:
        {
            
        }
            break;
        case 1002:
        {
            //            if (delegate!=nil && [delegate performSelector:@selector(HtimerTitle:)]) {
            [self.delegate HtimerTitle:self.timeTitle];
            
            //}
            NSLog(@"timeTitle = %d",self.timeTitle);
        }
            break;
        case 1003:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)setDelegate:(id<HChartDelegate>)theDelegate
{
    delegate = theDelegate;
}

#pragma  mark - pickView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayTimes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayTimes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag ==20) {
        self.timeTitle = [[arrayTitle objectAtIndex:row] intValue];
        NSLog(@"string = %d",timeTitle);
        
    }else{
        charts = row;
        NSLog(@"new =  %d",row);  
        
    } 
}

-(void)initModels{
    //line
    HChartModel *model = [[HLineChartModel alloc] init];
    [self addModel:model withName:@"line"];
    
    //area
    model = [[HAreaChartModel alloc] init];
    [self addModel:model withName:@"area"];
    
    //column
    model = [[HColumnChartModel alloc] init];    
    //  [self addModel:model withName:@"column"];
    
    //candle
    model = [[HCandleChartModel alloc] init];
    [self addModel:model withName:@"candle"];
    
}
-(void)addModel:(HChartModel *)model withName:(NSString *)name{
    [self.models setObject:model forKey:name];
}

-(HChartModel *)getModel:(NSString *)name{
    return [self.models objectForKey:name];
}

- (void)drawRect:(CGRect)rect {
	[self initChart];
	[self initSections];
	[self initXAxis];
	[self initYAxis];
	[self drawXAxis];
	[self drawYAxis];
	[self drawChart];
}



#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *ts = [touches allObjects];
	self.touchFlag = 0;
	self.touchFlagTwo = 0;
	if([ts count]==1){
		UITouch* touch = [ts objectAtIndex:0];
        //开始的点的坐标//==========
        beginX=[touch locationInView:self].x;
        movingX=0;
        //=========       
		if([touch locationInView:self].x < 40){
		    self.touchFlag = [touch locationInView:self].y;
		}
	}else if ([ts count]==2) {
		self.touchFlag = [[ts objectAtIndex:0] locationInView:self].x ;
		self.touchFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *ts = [touches allObjects];	
    UITouch* touch = [ts objectAtIndex:0];
    
    if (movingX!=0) {
        if (([touch locationInView:self].x-movingX)<0) {
            beginX=movingX;
        } 
    }
    movingX=[touch locationInView:self].x;
    if ([ts count]==1) {
        int i = [self getIndexOfSection:[touch locationInView:self]];
		if(i!=-1){
			HSection *sec = [self.sections objectAtIndex:i];
            
			int interval = 1;
			if([touch locationInView:self].x > sec.paddingLeft){
				if(abs([touch locationInView:self].x - beginX) >= MIN_INTERVAL){
					if([touch locationInView:self].x - beginX > 0){
						if(self.plotCount > (self.rangeTo-self.rangeFrom)){
							if(self.rangeFrom - interval >= 0){
								self.rangeFrom -= interval;
								self.rangeTo   -= interval;
								if(self.selectedIndex >= self.rangeTo){
									self.selectedIndex = self.rangeTo-1;
								}
							}else{
                                
								self.rangeFrom = 0;
								self.rangeTo  -= self.rangeFrom;
								if(self.selectedIndex >= self.rangeTo){
									self.selectedIndex = self.rangeTo-1;
								}
							}
							[self setNeedsDisplay];
						}
					}else{
						if(self.plotCount > (self.rangeTo-self.rangeFrom)){
							if(self.rangeTo + interval <= self.plotCount){
								self.rangeFrom += interval;
								self.rangeTo += interval;
								if(self.selectedIndex < self.rangeFrom){
									self.selectedIndex = self.rangeFrom;
								}
							}else {
								self.rangeFrom  += self.plotCount-self.rangeTo;
								self.rangeTo     = self.plotCount;
								
								if(self.selectedIndex < self.rangeFrom){
									self.selectedIndex = self.rangeFrom;
								}
							}
                            [self setNeedsDisplay];
						}
					}
				}
			}
		} 
    }   else if ([ts count]==2) {
        
		float currFlag = [[ts objectAtIndex:0] locationInView:self].x;
		float currFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
        
		if(self.touchFlag == 0){
		    self.touchFlag = currFlag;
			self.touchFlagTwo = currFlagTwo;
		}else{
			int interval = 5;
			
			if((currFlag - self.touchFlag) > 0 && (currFlagTwo - self.touchFlagTwo) > 0){
				if(self.plotCount > (self.rangeTo-self.rangeFrom)){
					if(self.rangeFrom - interval >= 0){
						self.rangeFrom -= 1;
						self.rangeTo   -= 1;
						if(self.selectedIndex >= self.rangeTo){
							self.selectedIndex = self.rangeTo-1;
						}
					}else {
						self.rangeFrom = 0;
						self.rangeTo  -= self.rangeFrom;
                        NSLog(@"123");
                        
						if(self.selectedIndex >= self.rangeTo){
							self.selectedIndex = self.rangeTo-1;
						}
					}
					[self setNeedsDisplay];
				}
			}else if((currFlag - self.touchFlag) < 0 && (currFlagTwo - self.touchFlagTwo) < 0){
				if(self.plotCount > (self.rangeTo-self.rangeFrom)){
					if(self.rangeTo + interval <= self.plotCount){
						self.rangeFrom += interval;
						self.rangeTo += interval;
						if(self.selectedIndex < self.rangeFrom){
							self.selectedIndex = self.rangeFrom;
						}
					}else {
						self.rangeFrom  += self.plotCount-self.rangeTo;
						self.rangeTo     = self.plotCount;
						
						if(self.selectedIndex < self.rangeFrom){
							self.selectedIndex = self.rangeFrom;
						}
					}
					[self setNeedsDisplay];
				}
			}else {
				if(abs(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag)) >= MIN_INTERVAL){
					if(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag) > 0){
						if(self.plotCount>self.rangeTo-self.rangeFrom){
							if(self.rangeFrom + interval < self.rangeTo){
								self.rangeFrom += interval;
							}
							if(self.rangeTo - interval > self.rangeFrom){
								self.rangeTo -= interval;
							}
						}else{
							if(self.rangeTo - interval > self.rangeFrom){
								self.rangeTo -= interval;
							}
						}
						[self setNeedsDisplay];
					}else{
						
						if(self.rangeFrom - interval >= 0){
							self.rangeFrom -= interval;
						}else{
							self.rangeFrom = 0;
						}
						self.rangeTo += interval;
						[self setNeedsDisplay];
					}
				}
			}
		}
		self.touchFlag = currFlag;
		self.touchFlagTwo = currFlagTwo;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *ts = [touches allObjects];	
	UITouch* touch = [[event allTouches] anyObject];
	if([ts count]==1){
		int i = [self getIndexOfSection:[touch locationInView:self]];
		if(i!=-1){
			HSection *sec = [self.sections objectAtIndex:i];
			if([touch locationInView:self].x > sec.paddingLeft){
				if(sec.paging){
					[sec nextPage];
					[self setNeedsDisplay];
				}else{
					[self setSelectedIndexByPoint:[touch locationInView:self]];
				}
			}
		}
	}
	self.touchFlag = 0;
}
@end
