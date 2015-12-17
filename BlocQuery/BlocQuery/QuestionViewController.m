//
//  QuestionViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/16/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.questionTextView.text = self.questionText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


@end
