//
//  LoginViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/8/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

//the protocol defines what the delegate is actually supposed to do
//QuestionsViewController will implement this method in order to retrieve the username value
@protocol LoginViewDelegate<NSObject>

-(void)loginViewControllerValue:(NSString *)username;

@end

@interface LoginViewController : UIViewController <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

@property (nonatomic, weak) id <LoginViewDelegate> delegate;

@end





