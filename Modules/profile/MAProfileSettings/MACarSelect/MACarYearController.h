//
//  MACarYearController.h
//  Mazda
//
//  Created by Nikita Merkel on 26.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"

@protocol MACarYearDelegate <NSObject>
@optional
-(void)didEnterYear:(int)carYear;
@end

@interface MACarYearController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *carYear;

@property (weak, nonatomic) id<MACarYearDelegate> delegate;

@end
