//
//  ViewController.h
//  Football
//
//  Created by ucan on 15/12/28.
//  Copyright © 2015年 ucan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *num_TF;

- (IBAction)buttonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)showResultAction:(id)sender;

@end

