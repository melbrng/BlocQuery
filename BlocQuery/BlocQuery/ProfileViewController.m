//
//  ProfileViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 1/13/16.
//  Copyright © 2016 melbo. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *profileDescriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileFirstnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLastnameLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;

- (IBAction)saveButton:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileUsernameLabel.text = self.profileUser.username;
    self.profileFirstnameLabel.text = self.profileUser[@"firstname"];
    self.profileLastnameLabel.text = self.profileUser[@"lastname"];
    self.profileDescriptionTextField.text = self.profileUser[@"description"];
    
    NSLog(@"currentUser : %@",[PFUser currentUser].username);
     NSLog(@"loggedInUser : %@",self.profileUser.username);
    
    if ([PFUser currentUser].username  != self.profileUser.username)
    {
        [self.saveBarButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButton:(id)sender {
}
@end
