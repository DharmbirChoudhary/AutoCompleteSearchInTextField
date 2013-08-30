//
//  ViewController.m
//  EmailReader
//
//  Created by Dharmbir Choudhary on 29/08/13.
//  Copyright (c) 2013 Dharmbir Choudhary. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize emailTxtFld,tblView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    tblView.layer.cornerRadius = 10.0;
    tblView.layer.masksToBounds = YES;
    
    [self emailContact];
    
}

- (void)emailContact

{
    emailArr = [[NSMutableArray alloc]init];
    searchArray = [[NSMutableArray alloc]init];
    emailAddedArr = [[NSMutableArray alloc]init];
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++)
        {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
            [allEmails addObject:email];
            
            NSLog(@"EMAIL %@",email);
        }
        CFRelease(emails);
    }
    
emailArr = allEmails;
    
    NSLog(@"All Email %@",emailArr);

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([emailAddedArr count] == 0)
    {
        [self searchAutocompleteEntriesWithSubstring:searchStr];
    }
    else
    {
        NSArray *myArray = [searchStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        [self searchAutocompleteEntriesWithSubstring:[myArray lastObject]];
    }
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //5.1 you do not need this if you have set SettingsCell as identifier in the storyboard (else you can remove the comments on this code)
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = [searchArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [emailAddedArr addObject:[searchArray objectAtIndex:indexPath.row]];
    
    NSString *emailStr = @"";
    
    if ([emailAddedArr count] == 1)
    {
        emailTxtFld.text = [NSString stringWithFormat:@"%@,",[emailAddedArr objectAtIndex:indexPath.row]];
    }
    else
    {
        
        
        for (NSString *email in emailAddedArr)
        {
            emailStr = [emailStr stringByAppendingString:[NSString stringWithFormat:@"%@,",email]];
        }
        emailTxtFld.text = emailStr;
        emailStr = [emailStr substringWithRange:NSMakeRange(0, [emailStr length] - 1)];
    }
    
    tblView.hidden = YES;
    
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    NSLog(@"Search Text %@",substring);
    
    [searchArray removeAllObjects];
    
    for(NSString *curString in emailArr)
    {
        NSRange substringRange = [curString rangeOfString:substring options:NSCaseInsensitiveSearch];
        if (substringRange.location == 0)
        {
            [searchArray addObject:curString];
        }
    }
    
    if ([searchArray count] > 0)
    {
         tblView.hidden = NO;
    }
    
   
    
    if ([UIScreen mainScreen].bounds.size.height >= 548)
    {
        if (searchArray.count>5)
        {
            tblView.scrollEnabled = YES;
            tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 80);
        }        
        else
        {
            tblView.scrollEnabled = NO;
            tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 44*searchArray.count);
        }
    }
    else
    {
        if (searchArray.count>3)
        {
            tblView.scrollEnabled   = YES;
            tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, 274, 50);
        }
        else
        {
            tblView.scrollEnabled   = NO;
            tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y,self.tblView.frame.size.width, 44*searchArray.count);
        }
    }
    
    [tblView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
