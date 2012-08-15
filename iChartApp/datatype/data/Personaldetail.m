//
//  Personaldetail.m
//  iChartApp
//
//  Created by bin huang on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////newsssss

#import "Personaldetail.h"
#import "dataBase.h"
@implementation Personaldetail
@synthesize productname=_productname,open=_open,high=_high,low=_low,volume=_volume,id=_id,time=_time;



-(Personaldetail *)initWithproductname:(NSString *)theproductname open:(NSString *)theopen high:(NSString *)thehigh low:(NSString *)thelow volume:(NSString *)thevolume id:(NSString *)theid time:(NSString *)thetime
{
self = [super init];
if (self) {
    self.productname=theproductname;
    self.open=theopen;
    self.high=thehigh;
    self.low=thelow;
    self.volume=thevolume;
    self.id=theid;
    self.time=thetime;
    
}
return self;

}
+(NSMutableArray *)findall{
    sqlite3 *db =[dataBase openDB];
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db,"select * from peizhi order by ID desc",-1,&stmt,nil);
    if (result == SQLITE_OK) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            const unsigned char * userproductname=sqlite3_column_text(stmt,0);
            //Personaldetail *user=[[Personaldetail alloc]initWithproductname:[NSString stringWithUTF8String:(const char *)userproductname] open:[NSString stringWithUTF8String:(const char *)useropen] high:[NSString stringWithUTF8String:(const char *)userhigh] low:[NSString stringWithUTF8String:(const char *)userlow] volume:[NSString stringWithUTF8String:(const char *)uservolume]];
            [array addObject:[NSString stringWithUTF8String:(const char *)userproductname]];

        }
        
        sqlite3_finalize(stmt);
        return array;

    }else {
        NSLog(@"find all failed with %d",result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }

}
+(Personaldetail *)findpersonaldetailwithproductname:(NSString *)theproductname{
    sqlite3 * db = [dataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db,"select * from product where productname=? limit 1",-1,&stmt,nil);
    
    
    if (result == SQLITE_OK) 
    {
        
        sqlite3_bind_text(stmt,1,[theproductname UTF8String],-1,nil);
        
        if (SQLITE_ROW == sqlite3_step(stmt)) 
        {
            const unsigned char * userproductname=sqlite3_column_text(stmt,0);
            const unsigned char * useropen=sqlite3_column_text(stmt,1);
            const unsigned char * userhigh=sqlite3_column_text(stmt,2);
            const unsigned char * userlow=sqlite3_column_text(stmt,3);
            const unsigned char * uservolume=sqlite3_column_text(stmt,4);
            const unsigned char * userid=sqlite3_column_text(stmt,5);
            const unsigned char * usertime=sqlite3_column_text(stmt,6);
            
            
//            NSString * productname;
//            if (userproductname == nil) 
//            {
//                productname = @"";
//            }else {
//                productname = [NSString stringWithUTF8String:(const char *)userproductname];
//            }
            
            
            
            NSString * open;
            if (useropen == nil) 
            {
                open = @"";
            }else {
                open = [NSString stringWithUTF8String:(const char *)useropen];
            }
            
            
            NSString * high;
            if (userhigh == nil) 
            {
                high = @"";
            }else {
                high = [NSString stringWithUTF8String:(const char *)userhigh];
            }
            
            
            NSString * volume;
            if (uservolume == nil) 
            {
                volume = @"";
            }else {
                volume = [NSString stringWithUTF8String:(const char *)uservolume];
            }
            
            
            NSString * id;
            if (userid == nil) 
            {
                id = @"";
            }else {
                id = [NSString stringWithUTF8String:(const char *)userid];
            }
            
            
            NSString * low;
            if (userlow == nil) 
            {
                low = @"";
            }else {
                low = [NSString stringWithUTF8String:(const char *)userlow];
            }
            
            
            
            
            NSString * time;
            if (usertime == nil) 
            {
                time = @"";
            }else {
                time = [NSString stringWithUTF8String:(const char *)usertime];
            }
            
            
            
            
            Personaldetail *user=[[Personaldetail alloc]initWithproductname:[NSString stringWithUTF8String:(const char *)userproductname] open:open high:high low:low volume:volume id:id time:time];
            NSLog(@"PersonaldetailPersonaldetailPersonaldetailPersonaldetail = %@, ====   %@",user.productname,user.open);
            sqlite3_finalize(stmt);
            return user;
        } 
    }else 
    {
        NSLog(@"faild with %d",result);
    }
    sqlite3_finalize(stmt);
    return nil;
}
+(int)upDateWithOpen:(NSString *)theOpen High:(NSString *)theHigh Low:(NSString *)theLow Vlume:(NSString *)theVolume Time:(NSString *)theTime fromid:(NSString *)theid{
    sqlite3 * db = [dataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"update product set open = ?,high = ?,low = ?,volume = ?,time = ? where id = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1,[theOpen UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2,[theHigh UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3,[theLow UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 4,[theVolume UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 6,[theid UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 5,[theTime UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return result;
}
+(int)addproductname:(NSString *)theproductname open:(NSString *)theopen high:(NSString *)thehigh low:(NSString *)thelow volume:(NSString *)thevolume id:(NSString *)theid time:(NSString *)thetime{

sqlite3 * db = [dataBase openDB];
sqlite3_stmt * stmt = nil;
sqlite3_prepare_v2(db,"insert into product(productname,open,high,low,volume,id,time) values(?,?,?,?,?,?,?)",-1, &stmt,nil);
sqlite3_bind_text(stmt, 1,[theproductname UTF8String], -1, nil);
sqlite3_bind_text(stmt, 2,[theopen UTF8String], -1, nil);
sqlite3_bind_text(stmt, 3,[thehigh UTF8String], -1, nil);
sqlite3_bind_text(stmt, 4,[thelow UTF8String], -1, nil);
sqlite3_bind_text(stmt, 5,[thevolume UTF8String], -1, nil);
sqlite3_bind_text(stmt, 6,[theid UTF8String], -1, nil);
sqlite3_bind_text(stmt, 7,[thetime UTF8String], -1, nil);

int result = sqlite3_step(stmt);
sqlite3_finalize(stmt);
return result;

}
+(int)addproductname:(NSString *)theproductname  id:(NSString *)theid type:(NSString *)thetype{
sqlite3 * db = [dataBase openDB];
sqlite3_stmt * stmt = nil;
sqlite3_prepare_v2(db,"insert into peizhi(productname,id,type) values(?,?,?)",-1, &stmt,nil);
sqlite3_bind_text(stmt, 1,[theproductname UTF8String], -1, nil);

sqlite3_bind_text(stmt, 2,[theid UTF8String], -1, nil);
sqlite3_bind_text(stmt, 3,[thetype UTF8String], -1, nil);

int result = sqlite3_step(stmt);
sqlite3_finalize(stmt);
return result;

}

@end
