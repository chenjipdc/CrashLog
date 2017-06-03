//
//  RSTableModel.h
//  RSDebugCrash
//
//  Created by pdc on 2017/6/1.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSLogBaseModel : NSObject
@property (nonatomic, strong) NSDate *createDate;

+(NSString *)className;

+(NSString *)sqlCreateTable;
+(NSString *)sqlTypeFromPropertyName:(NSString *)propertyName;
+(NSString *)sqlAddColumnByPropertyName:(NSString *)propertyName;

+(NSString *)sqlClearTable;
+(NSString *)sqlDropTable;
@end

// ========== date log ===================
@interface RSLogDateModel : RSLogBaseModel
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger logDateId;

@end

// ========= time log ====================
@interface RSLogTimeModel : RSLogBaseModel
@property (nonatomic, assign) NSInteger logDateId;
@property (nonatomic, assign) NSInteger logTimeId;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *crashLog;
@property (nonatomic, copy) NSString *reachabilityStatus; //network status

+(NSString *)reachabilityStatus;
@end


// ============== device ================
@interface RSDeviceModel : RSLogBaseModel
@property (nonatomic, copy) NSString *name;   //device name
@property (nonatomic, copy) NSString *model;  //device model
@property (nonatomic, copy) NSString *localizedModel; //localized model
@property (nonatomic, copy) NSString *systemName; //system name
@property (nonatomic, copy) NSString *systemVersion;  //system version
@property (nonatomic, copy) NSString *uuid;   //uuid
@property (nonatomic, copy) NSString *appVersion; //app short version

+(NSString *)name;
+(NSString *)model;
+(NSString *)localizedModel;
+(NSString *)systemName;
+(NSString *)systemVersion;
+(NSString *)uuid;
+(NSString *)appVersion;

@end
