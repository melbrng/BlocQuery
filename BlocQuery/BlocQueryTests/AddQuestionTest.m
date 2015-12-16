//
//  AddQuestionTest.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/16/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>




@interface AddQuestionTest : XCTestCase

@end

@implementation AddQuestionTest

- (void)setUp {
    [super setUp];
    
    [Parse setApplicationId:@"Gymx0tmbAzgrfhtycAOa4yj3zjvK0Nmo2XA5miNu"
                  clientKey:@"NyELiHuZXBDftIGpNANCVRSA8lsrVo1i3x0Z6fzk"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQuestionForTestUser1 {
    
    //get testUser1
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:@"testUser1"]; // find all the women
    NSArray *users = [query findObjects];
    
    
    PFObject *questionObject = [PFObject objectWithClassName:@"Question"];
    
    questionObject[@"questionText"] = @"This is a test question for testUser1?";
    questionObject[@"user"] = [users objectAtIndex:0];
    
    [questionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
}

- (void)testQuestionForTestUser2 {
    
    //get testUser1
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:@"testUser2"]; // find all the women
    NSArray *users = [query findObjects];
    
    
    PFObject *questionObject = [PFObject objectWithClassName:@"Question"];
    
    questionObject[@"questionText"] = @"This is a test question for testUser2?";
    questionObject[@"user"] = [users objectAtIndex:0];
    
    [questionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
