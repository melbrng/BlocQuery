//
//  QueryTableViewCell.h
//  BlocQuery
//
//  Created by Melissa Boring on 1/15/16.
//  Copyright © 2016 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QueryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *queryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *answersLabel;


@end
