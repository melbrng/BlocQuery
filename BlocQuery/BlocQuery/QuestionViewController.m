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

@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (strong,nonatomic) NSArray *answers;
@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self queryForAnswers];
    
    self.navigationController.navigationBar.topItem.title = @"Questions";
    
    self.questionTextLabel.text = self.question[@"questionText"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self queryForAnswers];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AnswerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    PFObject* answer = (PFObject*)[self.answers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = answer[@"answerText"];
  
    NSDate *createdAt = answer.createdAt;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    cell.detailTextLabel.text = dateString;
    
    return cell;
}

#pragma mark - Query

-(void)queryForAnswers
{
    // create a relation based on the authors key
    PFRelation *relation = [self.question relationForKey:@"answers"];
    
    // generate a query based on that relation
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
   // self.answers =[query findObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            self.answers = objects;
            
            [self.answerTableView reloadData];
        }
        else
        {
            //log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addAnswer"])
    {
        
        AnswerViewController *answerController = [segue destinationViewController];
        answerController.question = self.question;
        
    }
}


@end
