//
//  DetailViewController.m
//  EveryDo2
//
//  Created by Andrew on 2017-10-25.
//  Copyright © 2017 Andrew. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITextField *todoTitleField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityPickerControl;
@property (weak, nonatomic) IBOutlet UITextView *todoDescriptionField;
@property (weak, nonatomic) IBOutlet UINavigationItem *navbarTitle;
- (IBAction)dismissKeyboardButton:(UIButton *)sender;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem.todoDescription;
    }
    
    
    if (self.detailItem.title.length != 0) {
        self.navbarTitle.title = self.detailItem.title;
        
        if ([self.detailItem.title isEqualToString:@"New Todo"]) {
            self.todoTitleField.text = @"";
        } else {
            self.todoTitleField.text = self.detailItem.title;
        }
        

    }
    
    self.priorityPickerControl.selectedSegmentIndex = self.detailItem.todoPriority;
    
    if (self.detailItem.todoDescription.length != 0) {
        self.todoDescriptionField.text = self.detailItem.todoDescription;
    }
    
    
    
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(@"keyboardWillShowNotification:")
                                                 name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(@"keyboardWillHideNotification:")
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShowNotification:(NSNotification *)notification
{
    [self updateBottomLayoutConstraintWithNotification: notification];
}

-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    [self updateBottomLayoutConstraintWithNotification: notification];
}

-(void)updateBottomLayoutConstraintWithNotification:(NSNotification *)notification
{
    NSDictionary<NSString *, NSValue *> *userInfo = notification.userInfo;
    CGRect keyboardEndFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect convertedKeyboardEndFrame = [self.view convertRect:keyboardEndFrame toView:self.view.window];
    CGFloat newKeyboardBufferHeight = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame);
    
    self.bottomLayoutConstraint.constant = newKeyboardBufferHeight + 32;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveTodo];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(Todo *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.todoDescriptionField becomeFirstResponder];
    return YES;
}



- (void)saveTodo {
    
    NSString *todoTitle = [self.todoTitleField.text isEqualToString:@""] ? @"New Todo" : self.todoTitleField.text;
    
    self.navbarTitle.title = todoTitle;
    self.detailItem.title = todoTitle;
    
    self.detailItem.todoPriority = self.priorityPickerControl.selectedSegmentIndex;
    self.detailItem.todoDescription = self.todoDescriptionField.text;
}


- (IBAction)dismissKeyboardButton:(UIButton *)sender {
    [self.view endEditing:YES];
}
@end
