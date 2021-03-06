//
//  VSRepository.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRepository.h"
#import "VSList.h"


@implementation VSRepository

@dynamic name;
@dynamic order;
@dynamic lists;
@dynamic finishedRound;
@dynamic wordsTotal;

+ (NSArray *)allRepos
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSRepository" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    return [[[VSUtils currentMOContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)finishThisRound
{
    self.finishedRound = [NSNumber numberWithInt:[self.finishedRound intValue] + 1];
    for (VSList *listInRepo in self.lists) {
        listInRepo.status = [VSConstant LIST_STATUS_NEW];
    }
    [VSUtils saveEntity];
}

- (NSArray *)orderedList
{
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    return [[self.lists allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (VSList *)firstListInRepo
{
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    NSPredicate *repoPredicate = [NSPredicate predicateWithFormat:@"(repository = %@)", self];
    [listRequest setPredicate:repoPredicate];
    [listRequest setFetchLimit:1];
    NSError *error = nil;
    NSArray *result = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    return [result objectAtIndex:0];
}

- (int) wordsInRepo
{
    int count = 0;
    for (VSList *list in self.lists) {
        count += [list.listVocabularies count];
    }
    return count;
}

- (int) rememberedInRepo
{
    int count = 0;
    for (VSList *list in self.lists) {
        for (VSListVocabulary *listVocabulary in list.listVocabularies) {
            if ([listVocabulary.lastStatus isEqualToNumber:[VSConstant VOCABULARY_LIST_STATUS_REMEMBERED]]) {
                count++;
            }
        }
    }
    return count;
}


- (UIImage *)repoImage
{
    if ([self.name rangeOfString:@"分类"].location != NSNotFound) {
        return [VSUtils fetchImg:@"BookBlack"];
    }
    else {
        return [VSUtils fetchImg:@"BookRed"];
    }
}

- (BOOL)isCategoryRepo
{
    return [self.name rangeOfString:@"分类"].location != NSNotFound;
}

- (UIColor *)repoNameColor
{
    return [UIColor colorWithHue:50.0/360.0 saturation:0.6 brightness:1 alpha:0.9];
}

- (NSString *)displayName
{
    NSRange range;
    if ((range = [self.name rangeOfString:@"GRE"]).location != NSNotFound || (range = [self.name rangeOfString:@"TOEFL"]).location != NSNotFound || (range = [self.name rangeOfString:@"GMAT"]).location != NSNotFound || (range = [self.name rangeOfString:@"IELTS"]).location != NSNotFound || (range = [self.name rangeOfString:@"四级"]).location != NSNotFound || (range = [self.name rangeOfString:@"六级"]).location != NSNotFound || (range = [self.name rangeOfString:@"SAT"]).location != NSNotFound) {
        NSRange remainRange;
        remainRange.location = range.length;
        remainRange.length = [self.name length] - range.length;
        return [NSString stringWithFormat:@"%@\n%@", [self.name substringWithRange:range], [self.name substringWithRange:remainRange]];
    }
    return @"";
}

- (NSString *)titleName
{
    NSRange range;
    if ((range = [self.name rangeOfString:@"GRE"]).location != NSNotFound || (range = [self.name rangeOfString:@"TOEFL"]).location != NSNotFound || (range = [self.name rangeOfString:@"GMAT"]).location != NSNotFound || (range = [self.name rangeOfString:@"IELTS"]).location != NSNotFound || (range = [self.name rangeOfString:@"四级"]).location != NSNotFound || (range = [self.name rangeOfString:@"六级"]).location != NSNotFound || (range = [self.name rangeOfString:@"SAT"]).location != NSNotFound) {
        NSRange remainRange;
        remainRange.location = range.length;
        remainRange.length = [self.name length] - range.length;
        return [NSString stringWithFormat:@"%@ %@", [self.name substringWithRange:range], [self.name substringWithRange:remainRange]];
    }
    return @"";
}

@end
