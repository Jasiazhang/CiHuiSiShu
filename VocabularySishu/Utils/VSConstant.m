//
//  VSConstant.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/22/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSConstant.h"

@implementation VSConstant

+ (NSNumber *)LIST_STATUS_NEW
{
    return [NSNumber numberWithInt:0];
}

+ (NSNumber *)LIST_STATUS_PROCESSING
{
    return [NSNumber numberWithInt:1];
}

+ (NSNumber *)LIST_STATUS_FINISH
{
    return [NSNumber numberWithInt:2];
}

+ (NSNumber *)VOCABULARY_LIST_STATUS_NEW
{
    return [NSNumber numberWithInt:0];
}

+ (NSNumber *)VOCABULARY_LIST_STATUS_REMEMBERED
{
    return [NSNumber numberWithInt:1];
}

+ (NSNumber *)VOCABULARY_LIST_STATUS_FORGOT
{
    return [NSNumber numberWithInt:2];
}

+ (NSNumber *)LIST_TYPE_NORMAL
{
    return [NSNumber numberWithInt:0];
}

+ (NSNumber *)LIST_TYPE_HISTORY
{
    return [NSNumber numberWithInt:1];
}

+ (NSNumber *)LIST_TYPE_SHORTTERM_REVIEW
{
    return [NSNumber numberWithInt:2];
}

+ (NSNumber *)LIST_TYPE_LONGTERM_REVIEW
{
    return [NSNumber numberWithInt:3];
}

+ (NSNumber *)REMEMBER_STATUS_GOOD
{
    return [NSNumber numberWithInt:1];
}

+ (NSNumber *)REMEMBER_STATUS_BAD
{
    return [NSNumber numberWithInt:0];  
}

@end
