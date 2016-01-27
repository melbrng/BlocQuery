//
//  QuestionViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/16/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "QuestionViewController.h"
#import "AnswerViewController.h"
#import "AnswerTableViewCell.h"


@interface QuestionViewController ()
@property (weak, nonatomic) IBOutlet UIView *questionHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

static UIFont *lightFont;
static NSParagraphStyle *paragraphStyle;
static BOOL firstLoad;

@implementation QuestionViewController

//Storyboard
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"answerText";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
        firstLoad = YES;
        
    }
    return self;
}


- (PFQuery *)queryForTable
{

    // create a relation based on the authors key
    PFRelation *relation = [self.question relationForKey:@"answers"];
    
    // generate a query based on that relation
    PFQuery *query = [relation query];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0)
    {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"votes"];
    
    
    CGFloat questionFontSize = 10;
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 2.0;
    mutableParagraphStyle.firstLineHeadIndent = 2.0;
    
    //where ends of the lines should stop. A negative value indicates the right-most edge
    mutableParagraphStyle.tailIndent = -2.0;
    
    //how far each paragraph should be from the previous
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    paragraphStyle = mutableParagraphStyle;
    
    NSMutableAttributedString *mutableQuestionString = [[NSMutableAttributedString alloc] initWithString:self.question[@"questionText"]
        attributes:@{NSFontAttributeName : [lightFont fontWithSize:questionFontSize],NSParagraphStyleAttributeName : paragraphStyle}];
    
    self.questionLabel.text = [mutableQuestionString string];
    
    return query;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"AnswerCell";
    
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    [cell.upVotesButton addTarget:self action:@selector(upVoteAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.answerLabel.text = object[self.textKey];
    
    //set the tag of the button;this will be used to identify the selected answer in the objects array when calling upVoteAnswer
    cell.upVotesButton.tag = indexPath.row;

    NSNumber *upVotes = object[@"votes"];
    
    NSString *upVoteString = [NSString stringWithFormat:@"%d votes", [upVotes intValue]];
    cell.upVotesLabel.text = upVoteString;
   
    
    return cell;
}

-(void)upVoteAnswer:(UIButton *)sender
{
    
    PFObject *answer = self.objects[sender.tag];
    NSNumber *upVotes = answer[@"votes"];
    int i = [upVotes intValue];
    
    if ([sender isSelected] )
    {
        [sender setSelected:NO];
        i--;
    }
    else
    {
        [sender setSelected:YES];
        i ++;
    }
    
    answer[@"votes"] = [NSNumber numberWithInt:i];
    
    //TODO:Find a way to do this one time instead of everytime the button is selected/deselected
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)
        {
            NSLog(@"Successful save");
            
        }
        else
        {
            //TODO: This should be presented in an alertview
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

#pragma mark - AnswerViewDelegate

- (void)answerViewControllerDidAnswer:(PFObject *)answer
{
    [self.answers addObject:answer];
}


- (void)answerViewControllerDidSave:(PFObject *)answer
{
    if (answer)
    {

        [self loadObjects];
        
    }

}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddAnswer"])
    {
        
        AnswerViewController *answerController = [segue destinationViewController];
        
        //*** You ALWAYS forget to set the delegate ***
        answerController.delegate = self;
        answerController.question = self.question;
        
    }
}


- (IBAction)upVoteButton:(id)sender {
}
@end
