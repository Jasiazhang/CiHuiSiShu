//
//  Vocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vocabulary : NSManagedObject

@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSString * phonetic;
@property (nonatomic, retain) NSNumber * meet;

@end
