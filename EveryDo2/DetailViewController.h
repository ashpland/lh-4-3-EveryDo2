//
//  DetailViewController.h
//  EveryDo2
//
//  Created by Andrew on 2017-10-25.
//  Copyright © 2017 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryDo2+CoreDataModel.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Todo *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

