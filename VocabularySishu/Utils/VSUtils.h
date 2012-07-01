//
//  VSUtils.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSContext.h"
#import "VSVocabulary.h"

@class VSVocabulary;

@interface VSUtils : NSObject

+ (NSManagedObjectContext *)currentMOContext;

+ (void)saveEntity;

+ (UIImage *)fetchImg:(NSString *)imageName;

+ (NSDate *)getToday;

+ (BOOL) vocabularySame:(VSVocabulary *)first with:(VSVocabulary *)second;

+ (NSString *)normalizeString:(NSString *)source;

+ (NSDate *)converToNormalDate:(NSDate *)date;

+ (NSDate *)getNow;

@end
