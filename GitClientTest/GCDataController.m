//
//  GCDataController.m
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import "GCDataController.h"
#import "RepositoryModel.h"
#import "RepositoryMO+CoreDataClass.h"

#define resorseURL @"GitClientTest"
#define repoEntity @"Repository"

@implementation GCDataController

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

- (void)initializeCoreData {
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:resorseURL withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

- (NSArray *) getAllRepos {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:repoEntity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
    }

    return results;
}

- (void) saveRepos:(NSMutableArray *)repos {
    
    for (RepositoryModel *item in repos) {

         RepositoryMO *repoItem = [NSEntityDescription insertNewObjectForEntityForName:repoEntity inManagedObjectContext:self.managedObjectContext];
        repoItem.repoId = item.id;
        repoItem.fullName = item.full_name;
        repoItem.login = item.owner.login;
        repoItem.avatarURL = item.owner.avatar_url;
        
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
}

@end
