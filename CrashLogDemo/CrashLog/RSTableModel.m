//
//  RSTableModel.m
//  RSDebugCrash
//
//  Created by pdc on 2017/6/1.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSTableModel.h"
#import <objc/runtime.h>
#import <UIKit/UIDevice.h>

static NSDictionary<NSString *, NSString *> *_cloumn_name_type_dict_ = nil;
static NSMutableDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *_type_property_name_set_ = nil;

@protocol RSDataTypeModel <NSObject>
@optional
+(NSDictionary<NSString *, NSString *> *)mapByColumn;
+(NSArray<NSString *> *)createAttachs;
@end

@interface RSDataTypeModel : NSObject
@property (nonatomic, copy) NSString *columnName;
@property (nonatomic, copy) NSString *type;

@end

@implementation RSDataTypeModel

@end

@interface RSLogBaseModel()<RSDataTypeModel>

@end

@implementation RSLogBaseModel
+(NSString *)className
{
    return NSStringFromClass(self.class);
}

+(NSArray<RSDataTypeModel *> *)_columnsWithClass:(Class )cls
{
    NSMutableArray<RSDataTypeModel *> *arr = [NSMutableArray array];
    if ([[cls.superclass new] isKindOfClass:[RSLogBaseModel class]])
    {
        NSArray *columns = [cls _columnsWithClass:cls.superclass];
        if (columns)
        {
            [arr addObjectsFromArray:columns];
        }
    }
    
    NSMutableDictionary *typePropertyNameDict = [NSMutableDictionary dictionary];
    unsigned propertyCount = 0;
    objc_property_t *p_property = class_copyPropertyList(cls, &propertyCount);
    
    for (unsigned i = 0; i < propertyCount; ++i)
    {
        NSLog(@"\n");
        unsigned attributeCount = 0;
        objc_property_attribute_t *p_property_attribute = property_copyAttributeList(p_property[i], &attributeCount);
        
        NSString *type = nil;
        NSString *columnName = nil;
        for (unsigned j = 0; j < attributeCount; j++)
        {
            NSString *name = [NSString stringWithUTF8String:p_property_attribute[j].name];
            NSString *value = [NSString stringWithUTF8String:p_property_attribute[j].value];
            //            NSLog(@"name:%@ value:%@", name, value);
            if ([name isEqualToString:@"T"])
            {
                type = [self _mapTypeWithPropertyAttributeName:value];
            }
            if ([name isEqualToString:@"V"])
            {
                RSDataTypeModel *model = [RSDataTypeModel new];
                columnName = [value stringByReplacingOccurrencesOfString:@"_" withString:@""];
                if (columnName)
                {
                    typePropertyNameDict[columnName] = type;
                }
                
                if ([cls respondsToSelector:@selector(mapByColumn)])
                {
                    NSDictionary *dict = [self mapByColumn];
                    if (dict[columnName])
                    {
                        type = dict[columnName];
                    }
                }
                model.columnName = columnName;
                model.type = type;
                [arr addObject:model];
//                NSLog(@"name:%@ type:%@", columnName, type);
            }
        }
    }
    [self _cacheInfo:typePropertyNameDict];
    return [arr copy];
}

+(NSString *)_mapTypeWithPropertyAttributeName:(NSString *)name
{
    if (_cloumn_name_type_dict_ == nil)
    {
        _cloumn_name_type_dict_ = @{@"b":@"INTEGER",
                                    @"B":@"INTEGER",
                                    @"i":@"INTEGER",
                                    @"I":@"INTEGER",
                                    @"c":@"INTEGER",
                                    @"C":@"INTEGER",
                                    @"q":@"INTEGER",
                                    @"Q":@"INTEGER",
                                    @"f":@"REAL",
                                    @"F":@"REAL",
                                    @"@\"NSString\"":@"TEXT",
                                    @"@\"NSDate\"":@"REAL",
                                    @"@\"NSData\"":@"BLOB"};
    }
    NSString *type = _cloumn_name_type_dict_[name];
    if (type == nil) return @"unknown";
    return type;
}

+(void )_cacheInfo:(NSDictionary *)info
{
    if (_type_property_name_set_ == nil)
    {
        _type_property_name_set_ = [NSMutableDictionary dictionary];
    }
    if (!_type_property_name_set_[NSStringFromClass(self.class)])
    {
        _type_property_name_set_[NSStringFromClass(self.class)] = info;
    }
}

+(NSString *)sqlCreateTable
{
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ",NSStringFromClass(self.class)]];
    [sql appendString:@"("];
    NSArray<RSDataTypeModel *> *columns = [self _columnsWithClass:self.class];
    [columns enumerateObjectsUsingBlock:^(RSDataTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sql appendString:[NSString stringWithFormat:@"%@ %@",obj.columnName, obj.type]];
        if (idx != columns.count - 1)
        {
            [sql appendString:@","];
        }
    }];
    if ([self.class respondsToSelector:@selector(createAttachs)])
    {
        NSArray<NSString *> *attachs = [self createAttachs];
        [attachs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (sql.length > 0)
            {
                [sql appendString:@","];
            }
            [sql appendString:obj];
        }];
    }
    [sql appendString:@");"];
    return [sql copy];
}

+(NSString *)sqlTypeFromPropertyName:(NSString *)propertyName
{
    return [self _sqlTypeFromPropertyName:propertyName cls:self.class];
}

+(NSString *)_sqlTypeFromPropertyName:(NSString *)propertyName cls:(Class )cls
{
    if (!_type_property_name_set_[NSStringFromClass(cls)][propertyName])
    {
        return  _type_property_name_set_[NSStringFromClass(cls.superclass)][propertyName];
    }
    return  _type_property_name_set_[NSStringFromClass(cls)][propertyName];
}

+(NSString *)sqlAddColumnByPropertyName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@;",NSStringFromClass(self.class), propertyName, [self sqlTypeFromPropertyName:propertyName]];
}

+(NSString *)sqlClearTable
{
    return nil;
}
+(NSString *)sqlDropTable
{
    return [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;",NSStringFromClass(self.class)];
}
@end


#pragma mark - RSLogDateModel
@implementation RSLogDateModel
+(NSDictionary<NSString *, NSString *> *)mapByColumn
{
    return @{@"logDateId":@"INTEGER PRIMARY KEY AUTOINCREMENT"};
}
@end

#pragma mark - RSLogTimeModel
@implementation RSLogTimeModel
+(NSDictionary<NSString *, NSString *> *)mapByColumn
{
    return @{@"logTimeId":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"logDateId":@"INTEGER NOT NULL"};
}

+(NSArray<NSString *> *)createAttachs
{
    return @[[NSString stringWithFormat:@"FOREIGN KEY(logDateId) REFERENCES %@(logDateId)",NSStringFromClass(RSLogDateModel.class)]];
}

-(NSString *)reachabilityStatus
{
    return [RSLogTimeModel reachabilityStatus];
}

+(NSString *)reachabilityStatus
{
    return @"wifi";
}
@end


@implementation RSDeviceModel

-(NSString *)name
{
    if (_name) return _name;
    return [RSDeviceModel name];
}

-(NSString *)model
{
    if (_model) return _model;
    return [RSDeviceModel model];
}

-(NSString *)localizedModel
{
    if (_localizedModel) return _localizedModel;
    return [RSDeviceModel localizedModel];
}

-(NSString *)systemName
{
    if (_systemName) return _systemName;
    return [RSDeviceModel systemName];
}

-(NSString *)systemVersion
{
    if (_systemVersion) return _systemVersion;
    return [RSDeviceModel systemVersion];
}

-(NSString *)uuid
{
    if (_uuid) return _uuid;
    return [RSDeviceModel uuid];
}

-(NSString *)appVersion
{
    if (_appVersion) return _appVersion;
    return [RSDeviceModel appVersion];
}

+(NSString *)name
{
    return UIDevice.currentDevice.name;
}

+(NSString *)model
{
    return UIDevice.currentDevice.model;
}

+(NSString *)localizedModel
{
    return UIDevice.currentDevice.localizedModel;
}

+(NSString *)systemName
{
    return UIDevice.currentDevice.systemName;
}

+(NSString *)systemVersion
{
    return UIDevice.currentDevice.systemVersion;
}

+(NSString *)uuid
{
    return [[NSUUID UUID] UUIDString];
}

+(NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end
