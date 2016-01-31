//
//  LoginViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/8/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "LoginViewController.h"
#import "PFObject.h"
#import "PFUser.h"
#import "QuestionsViewController.h"

@interface LoginViewController ()

@property (strong,nonatomic) PFLogInViewController *logInController;
@property (strong,nonatomic) QuestionsViewController *questionsController;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    self.logInController = [[PFLogInViewController alloc] init];
    self.logInController.delegate = self;
    self.logInController.fields = (PFLogInFieldsUsernameAndPassword
                                   | PFLogInFieldsLogInButton
                                   | PFLogInFieldsSignUpButton
                                   | PFLogInFieldsPasswordForgotten
                                   | PFLogInFieldsDismissButton);
    
    //customize the logo
    UIFont *logoFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:50];
    UILabel *logoLabel = [[UILabel alloc]init];
    logoLabel.text = @"BlocQuery";
    logoLabel.textColor = [UIColor blackColor];
    logoLabel.font = logoFont;
    self.logInController.logInView.logo = logoLabel;
    [self.logInController.logInView.logo setFrame:CGRectMake(60.0, 12.0, 420.0, 68.0)];
    
    //SignUp view controller
    //TODO: Set a default profile image when a user signs up
    PFSignUpViewController *signUpController = [[PFSignUpViewController alloc]init];
    signUpController.delegate = self;
    self.logInController.signUpController = signUpController;
    [self presentViewController:self.logInController animated:YES completion:nil];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - LogIn Delegates

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    self.questionsController = [storyboard instantiateViewControllerWithIdentifier:@"QuestionsView"];
    NSString *loginUsername = self.logInController.logInView.usernameField.text;
    self.questionsController.username = loginUsername;

    [self.navigationController pushViewController:self.questionsController animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - SignUp Delegates

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
