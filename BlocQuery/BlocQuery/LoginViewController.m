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
#import "ViewController.h"

@interface LoginViewController ()

@property (strong,nonatomic) PFLogInViewController *logInController;
@property (strong,nonatomic) ViewController *viewController;

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
    
    //    UIImage *logo = [UIImage imageNamed:@"BlocQuery.png"];
    //    UIImageView *logoView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)];
    //    [logoView setImage:logo];
    //
    //    self.logInController.logInView.logo = logoView; // logo can be any UIView
    
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
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewView"];
    NSString *loginUsername = self.logInController.logInView.usernameField.text;
    self.viewController.username = loginUsername;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
