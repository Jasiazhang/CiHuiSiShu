//
//  VSConstant.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/22/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MEANINGTEMPLATE @"<div id='meaning'><ul>%@</ul></div>"

#define MEANINGLINETEMPLATE @"<li><div>%@</div><div>%@</div></li>"

#define VOCABULARY_LIST_STATUS_REMEMBERED 1
#define VOCABULARY_LIST_STATUS_NEW 0
#define VOCABULARY_LIST_STATUS_FORGOT 2

@interface VSConstant : NSObject

@end