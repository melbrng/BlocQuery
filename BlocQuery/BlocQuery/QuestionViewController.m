//
//  QuestionViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/16/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "QuestionViewController.h"
#import "AnswerViewController.h"


@interface QuestionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Questions";

//    UIBarButtonItem *addAnswerButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Answer"
//                                   style:UIBarButtonItemStylePlain
//                                   target:self
//                                   action:@selector(addAnswer:)];
//    
//    self.navigationItem.rightBarButtonItem = addAnswerButton;
    self.questionTextView.text = self.question[@"questionText"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
- (IBAction)addAnswer:(id)sender
{
    NSLog(@"Answering");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addAnswer"])
    {
        
        AnswerViewController *answerController = [segue destinationViewController];
        answerController.question = self.question;
        
    }
}


@end
