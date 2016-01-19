//
//  ProfileViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 1/13/16.
//  Copyright © 2016 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUser.h"

@interface ProfileViewController : UIViewController

@property (strong,nonatomic) PFUser *profileUser;

@end
