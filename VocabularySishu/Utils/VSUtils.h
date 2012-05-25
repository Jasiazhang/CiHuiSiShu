//
//  VSUtils.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSContext.h"

@class VSContext;

@interface VSUtils : NSObject

+ (NSManagedObjectContext *)currentMOContext;

+ (UIImage *)fetchImg:(NSString *)imageName;

+ (VSContext *)fetchContext;

+ (NSDate *)getToday;

@end
