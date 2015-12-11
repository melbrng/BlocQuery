//
//  Question.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/10/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Question : PFObject

@property (strong,nonatomic) PFUser *user;
@property (strong,nonatomic) NSString *questionText;

@end
