//
//  Datasource.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/15/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "Datasource.h"
#import "PFObject.h"
#import "PFUser.h"
#import "PFQuery.h"

@interface Datasource ()

@property (nonatomic,strong) NSError *error;

@end


@implementation Datasource


+ (instancetype) sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{

    self = [super init];
    
    if (self)
    {
        [self addUsersAndQuestions];
    }
    
    return self;
}

- (void) addUsersAndQuestions
{
//    PFQuery *testquery = [PFQuery queryWithClassName:@"User"];
//    [testquery whereKey:@"username" equalTo:@"testUser1"];
//    
//    [testquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username ='testUser1'"];
//    PFQuery *query = [PFQuery queryWithClassName:@"User" predicate:predicate];
//    NSArray* user1Array = [query findObjects];
//    
//    if(user1Array.count == 0 )
//    {
//        PFUser *user1 = [PFUser user];
//        user1.username = @"testUser2";
//        user1.password = @"pass";
//        user1.email = @"testUser2@example.com";
//        user1[@"phone"] = @"415-392-0202";
//        
//        [self signUpUser:user1];
//    }

    
    PFObject *questionObject = [PFObject objectWithClassName:@"Question"];
    
    questionObject[@"questionText"] = @"How long will the sun be out in June?";
    questionObject[@"user"] = [PFUser currentUser];

    [questionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];

}

-(NSError *)signUpUser:(PFUser *) user
{
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
         if (error)
         {
             self.error = error;
         }
        }];
    
    return self.error;
    
}


@end
