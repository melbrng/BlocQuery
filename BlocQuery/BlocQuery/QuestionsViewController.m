//
//  QuestionsViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/9/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "QuestionsViewController.h"
#import "QuestionViewController.h"
#import "ProfileViewController.h"
#import "PFQuery.h"
#import "Datasource.h"


@interface QuestionsViewController ()
- (IBAction)addQuestion:(id)sender;


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
        static NSString *cellIdentifier = @"QuestionCell";

        PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
        }
    
    cell.textLabel.text = object[self.textKey];

    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowQuestion"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *question = [self.objects objectAtIndex:indexPath.row];

        QuestionViewController *questionController = [segue destinationViewController];
        questionController.question = question;
        
    }
    else if ([[segue identifier] isEqualToString:@"ShowProfile"])
    {
        
        ProfileViewController *profileController = [segue destinationViewController];
        profileController.currentUser = [PFUser currentUser];
        
    }
}


- (IBAction)addQuestion:(id)sender
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Query"
                                                                   message:@"Ex: What is your favorite snack?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    

    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Question";
        textField.secureTextEntry = NO;
        
    }];
    
    
    UIAlertAction* addAction = [UIAlertAction actionWithTitle:@"Post"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                                    
                                //add the question here
                                PFObject *questionObject = [PFObject objectWithClassName:@"Question"];
                                                    
                                questionObject[@"questionText"] = alert.textFields[0].text;
                                questionObject[@"user"] = [PFUser currentUser];
                                                    
                                [questionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                        
                                            if (succeeded)
                                                {
                                                    NSLog(@"Successful save");
                                                    [self loadObjects];
                                                }
                                                else
                                                {
                                                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                                                }
                                            }];
                                                    
                                }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    
    [alert addAction:addAction];
    [alert addAction:cancelAction];

    [alert.view setNeedsLayout];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
