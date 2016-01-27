//
//  AnswerTableViewCell.h
//  BlocQuery
//
//  Created by Melissa Boring on 1/27/16.
//  Copyright © 2016 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upVotesLabel;
@property (weak, nonatomic) IBOutlet UIButton *upVotesButton;

@end
