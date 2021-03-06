//
//  VSAppDelegate.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSAppDelegate.h"
#import "VSNavigationBar.h"
#import "MobClick.h"
#import "iRate.h"
#import "VSAppRecord.h"
#import "VSListRecord.h"
#import "UMSocial.h"
#import "InAppPurchase.h"
#import "UMSocialConfig.h"

@implementation VSAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize viewController;
@synthesize guideViewController;

+ (void)initialize
{
	[iRate sharedInstance].appStoreID = [[VSUtils getAppId] integerValue];
    [iRate sharedInstance].applicationBundleID = [VSUtils getBundleId];
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].daysUntilPrompt = -1;
    [iRate sharedInstance].usesUntilPrompt = -1;
    [iRate sharedInstance].eventsUntilPrompt = 1;
    [iRate sharedInstance].remindPeriod = 5;
}

- (void)initEnv
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"playAfterOpen"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playAfterOpen"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)reloadSystemData
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *systemFilePath = [[cachePaths objectAtIndex:0] stringByAppendingPathComponent:@"VocabularySishu.sqlite"];
    
    NSURL* systemStoreURL = [NSURL fileURLWithPath:systemFilePath];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSPersistentStore * existedStore = [__persistentStoreCoordinator persistentStoreForURL:(NSURL *)systemStoreURL];
    if (![__persistentStoreCoordinator removePersistentStore:existedStore error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:systemStoreURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMSocialData setAppKey:[VSUtils getUMengKey]];
    [MobClick startWithAppkey:[VSUtils getUMengKey]];
    [UMSocialConfig setWXAppId:@"wxc94c96ef1461f297" url:[VSUtils getAppUrl]];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.title = @"词汇私塾，值得拥有！";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [VSUtils getAppUrl];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [VSUtils copySQLite];
    [self initEnv];
   
    if ([[VSAppRecord getAppRecord].migrated isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [VSDataUtil readWriteMigrate];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.viewController = [[VSHistoryViewController alloc] initWithNibName:@"VSHistoryViewController" bundle:nil];
    UINavigationController *navigationController = [self customizedNavigationController];

    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif && [localNotif.userInfo valueForKey:@"ListRecordName"] != nil) {
        NSString *name = [localNotif.userInfo objectForKey:@"ListRecordName"];
        VSListRecord* listRecord = [VSListRecord findByListName:name];
        application.applicationIconBadgeNumber -= 1;
        VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
        vocabularyListViewController.currentList = [listRecord getList];
        vocabularyListViewController.currentListRecord = listRecord;
        vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
        [navigationController pushViewController:vocabularyListViewController animated:NO];
        [application cancelLocalNotification:localNotif];
    }

    [InAppPurchase loadStore];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"launched"] ) {
        [VSUtils showGuidPage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState != UIApplicationStateActive) {
        [self handleNotification:application withNotification:notification];
    }
}

- (void)handleNotification:(UIApplication *)application withNotification:(UILocalNotification *)notification
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    NSDictionary *data = notification.userInfo;
    if ([data valueForKey:@"ListRecordName"] != nil) {
        NSString *name = [notification.userInfo objectForKey:@"ListRecordName"];
        VSListRecord* listRecord = [VSListRecord findByListName:name];
        application.applicationIconBadgeNumber -= 1;
        VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
        vocabularyListViewController.currentList = [listRecord getList];
        vocabularyListViewController.currentListRecord = listRecord;
        vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
        [navigationController pushViewController:vocabularyListViewController animated:NO];
        [application cancelLocalNotification:notification];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *userModelURL = [[NSBundle mainBundle] URLForResource:@"UserModel" withExtension:@"momd"];
    NSManagedObjectModel *userModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:userModelURL];

    NSURL *systemModelURL = [[NSBundle mainBundle] URLForResource:@"VocabularySishu" withExtension:@"momd"];
    NSManagedObjectModel *systemModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:systemModelURL];
    
    __managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:userModel, systemModel, nil]];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *systemFilePath = [[cachePaths objectAtIndex:0] stringByAppendingPathComponent:@"VocabularySishu.sqlite"];
    NSURL* systemStoreURL = [NSURL fileURLWithPath:systemFilePath];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userFilePath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"UserModel.sqlite"];
    NSURL* userStoreURL = [NSURL fileURLWithPath:userFilePath];

    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:userStoreURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:systemStoreURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (UINavigationController *)customizedNavigationController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];    
    if ([navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"Navigation.png"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            image = [UIImage imageNamed:@"Navigation-ios7.png"];
        }
        
        [navController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        navController.navigationBar.translucent = NO;
        navController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor]};
    }
    return navController;
}


@end
