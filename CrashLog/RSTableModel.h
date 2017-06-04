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


@interface RSLogDateModel : RSLogBaseModel
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger logDateId;

@end

@interface RSLogTimeModel : RSLogBaseModel
@property (nonatomic, assign) NSInteger logDateId;
@property (nonatomic, assign) NSInteger logTimeId;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *crashLog;

@end
