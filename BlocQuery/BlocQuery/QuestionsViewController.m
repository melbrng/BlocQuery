//
//  QuestionsViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/9/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "QuestionsViewController.h"
#import "QuestionViewController.h"
#import "PFQuery.h"
#import "Datasource.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

//Storyboard
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
 
       //  The className to query on
        self.parseClassName = @"Question";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"questionText";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
        self.title = @"Bloquery";
        
        
    }
    return self;
}


- (PFQuery *)queryForTable
{
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0)
    {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
        static NSString *cellIdentifier = @"QuestionCell";

        PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[self.textKey];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",  object[@"priority"]];

    return cell;
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    
//    PFObject *question = [self.objects objectAtIndex:indexPath.row];
//    
//    QuestionViewController *questionController = [[QuestionViewController alloc] init];
//    questionController.questionText = question[self.textKey];
//    
//    self prepareForSegue:<#(nonnull UIStoryboardSegue *)#> sender:<#(nullable id)#>
//    
//   // [[self navigationController] pushViewController:questionController animated:YES];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showQuestion"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *question = [self.objects objectAtIndex:indexPath.row];

        QuestionViewController *questionController = [segue destinationViewController];
        questionController.questionText = question[self.textKey];
        
    }
}


@end
