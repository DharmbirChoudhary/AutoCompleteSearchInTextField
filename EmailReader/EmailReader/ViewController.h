//
//  ViewController.h
//  EmailReader
//
//  Created by Dharmbir Choudhary on 29/08/13.
//  Copyright (c) 2013 Dharmbir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *emailArr;
    NSMutableArray *searchArray;
    NSMutableArray *emailAddedArr;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
