//
//  MAProfileSettingsController.h
//  Mazda
//
//  Created by Nikita Merkel on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "MARequests.h"
#import "MAProfileObject.h"
#import "MAProfileSettingsCell.h"
#import "MACitySelect.h"
#import "MACarSelectTableController.h"
#import "MACarYearController.h"
#import "MACityObject.h"
#import "MACarPhotos.h"
#import "MAImagePicker.h"

@interface MAProfileSettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MACitiesDelegate, MACarSelectDelegate, MACarYearDelegate, MACarPhotosDelegate>

@property (strong, nonatomic) MAProfileObject *profileObj;

@property (strong, nonatomic) MAUserCarObject *carObj;

@end
