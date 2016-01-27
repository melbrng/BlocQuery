//
//  AnswerViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/28/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "AnswerViewController.h"


@interface AnswerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
- (IBAction)submitAnswer:(id)sender;
@end

@implementation AnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Question";
    self.questionLabel.text = self.question[@"questionText"];
    
    [self.answerTextField becomeFirstResponder];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)submitAnswer:(id)sender
{
    PFObject *myAnswer = [PFObject objectWithClassName:@"Answer"];
    myAnswer[@"answerText"] = self.answerTextField.text;
    myAnswer[@"votes"] = [NSNumber numberWithInt:0];
    [myAnswer setObject:self.question forKey:@"question"];
    [myAnswer setObject:[PFUser currentUser] forKey:@"createdBy"];
    
    [myAnswer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)
        {
            NSLog(@"Successful save");
            
            //create the relation after successful save of myAnswer
            PFRelation *relation = [self.question relationForKey:@"answers"];
            [relation addObject:myAnswer];
            [self.question saveInBackground];

            [self.delegate answerViewControllerDidSave:myAnswer];
            
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
        else
        {
            //TODO: This should be presented in an alertview
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
  
}




@end
