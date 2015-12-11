//
//  ViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/6/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface ViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *successTextField;
@property (strong,nonatomic) NSString *username;

@end

