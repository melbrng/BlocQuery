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
#import "QueryTableViewCell.h"
#import "PFFile.h"


@interface QuestionsViewController ()

- (IBAction)addQuestion:(id)sender;

@property (nonatomic, strong) UITapGestureRecognizer *imageViewTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *labelTapGestureRecognizer;
@property (nonatomic, strong) PFUser *selectedUser ;

@end

@implementation QuestionsViewController

static NSString *cellIdentifier = @"QuestionCell";

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


-(void)viewDidAppear:(BOOL)animated
{
    [self loadObjects];
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
    
    //must use in order to retrieve the user associated with the query
    [query includeKey:@"user"];
    
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

//called each time before a row is displayed

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
    {
        
        QueryTableViewCell *queryCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        PFUser *queryUser = [object objectForKey:@"user"];
        
        //add gesture recognizers
        self.imageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapFired:)];
        [queryCell.profileImageView addGestureRecognizer:self.imageViewTapGestureRecognizer];
         queryCell.profileImageView.userInteractionEnabled = YES;
        queryCell.profileImageView.tag = indexPath.row;
        
        self.labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapFired:)];
        [queryCell.queryLabel addGestureRecognizer:self.labelTapGestureRecognizer];
        queryCell.queryLabel.userInteractionEnabled = YES;
        
        
        queryCell.queryLabel.text = object[self.textKey];
        queryCell.profileUsernameLabel.text = queryUser.username;
        
        PFFile *userImageFile = [queryUser objectForKey:@"profileImage"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error)
            {
                UIImage *profileImage = [UIImage imageWithData:imageData];
                queryCell.profileImageView.image = profileImage;
                
                if (profileImage == nil)
                {
                    queryCell.profileImageView.image = [UIImage imageNamed:@"BlocQuery.png"];
                }

            }
        }];
        
//        UIImage *profileImage = [queryUser objectForKey:@"profileImage"];
//        UIImage *defaultImage = [UIImage imageNamed:@"BlocQuery.png"];
//        
//        if (profileImage == nil)
//        {
//            queryCell.profileImageView.image = [UIImage imageNamed:@"BlocQuery.png"];
//        }

    return queryCell;
}

- (void) imageViewTapFired:(UITapGestureRecognizer *)sender
{
    
    self.selectedUser = [self.objects[sender.view.tag] objectForKey:@"user"];
    
    [self performSegueWithIdentifier:@"ShowProfile" sender:sender];
    
}

- (void) labelTapFired:(UITapGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"ShowQuestion" sender:sender];
}



#pragma mark -- Segue

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
        profileController.profileUser = self.selectedUser;
        
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
