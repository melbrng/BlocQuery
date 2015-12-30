//
//  AddAnswersTest.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/30/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>

@interface AddAnswersTest : XCTestCase
@property NSArray *questions;

@end

@implementation AddAnswersTest

- (void)setUp {
    [super setUp];
    [Parse setApplicationId:@"Gymx0tmbAzgrfhtycAOa4yj3zjvK0Nmo2XA5miNu"
                  clientKey:@"NyELiHuZXBDftIGpNANCVRSA8lsrVo1i3x0Z6fzk"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddAnswerExample
{
    //retrieve the testUser1 test question
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query whereKey:@"questionText" equalTo:@"This is a test question for testUser1?"];
    self.questions = [query findObjects];
    
    PFObject *question = [self.questions objectAtIndex:0];
    PFObject *myAnswer = [PFObject objectWithClassName:@"Answer"];
    myAnswer[@"answerText"] = @"testing answer for testUser1 question";
    [myAnswer setObject:question forKey:@"question"];
    [myAnswer setObject:[PFUser currentUser] forKey:@"createdBy"];
    [myAnswer save];
    
    //create the relation after successful save of myAnswer
    PFRelation *relation = [question relationForKey:@"answers"];
    [relation addObject:myAnswer];
    [question save];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
