//
//  TableViewController.m
//  StudentRecord
//
//  Created by IGC Technologies on 12/18/15.
//  Copyright © 2015 IGC Technologies. All rights reserved.
//

#import "TableViewController.h"
#import "CoreDataHandler.h"
#import "Students.h"
#import "AppDelegate.h"


#define kAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])


@interface TableViewController ()
@property(nonatomic,strong) NSArray  *students;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self readStudentRecord];
}


-(void) readStudentRecord{
     NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.students = [CoreDataHandler fetchEntitiesForClass:[Students class] withPredicate:nil andSortDescriprotArray:@[sorter] inManageObjectCOntext:kAppDelegate.managedObjectContext];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteAllRecord:(id)sender {
    [CoreDataHandler deleteAllManagedObjects:[Students class] inManagedObjectContext:kAppDelegate.managedObjectContext];
    [self readStudentRecord];
}

-(void)deleteHandler:(id)sender{
    UIButton *button = (UIButton *) sender;
    Students *student = self.students[button.tag];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"studentID",student.studentID];
    [CoreDataHandler deleteManagedObject:[Students class] withPredicate:predicate inManagedObjectContext:kAppDelegate.managedObjectContext];
    [self readStudentRecord];
}

-(void) updateRecord{
    Students *student = self.students[self.tableView.indexPathForSelectedRow.row];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Student Record Form"
                                  message:@"Update Student Credentials"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             UITextField *nameField = alert.textFields[0];
                             UITextField *studentIDField = alert.textFields[1];
                             NSLog(@"%@ %@", nameField.text, studentIDField.text);
                             
                             if (nameField.text.length>0 && studentIDField.text.length>0) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 student.name = nameField.text;
                                 student.studentID = studentIDField.text;
                                 [CoreDataHandler saveManagedObjectContext:kAppDelegate.managedObjectContext];
                                 [self readStudentRecord];
                             }
                             else{
                                 NSLog(@"Record not saved. Please enter both student name and student id");
                             }
                             
                             
                             
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = student.name;
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = student.studentID;
        
    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];

}


- (IBAction)addStudent:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Student Record Form"
                                  message:@"Enter Student Credentials"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                            
                             UITextField *nameField = alert.textFields[0];
                             UITextField *studentIDField = alert.textFields[1];
                             NSLog(@"%@ %@", nameField.text, studentIDField.text);
                             
                             if (nameField.text.length>0 && studentIDField.text.length>0) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 Students *student = [CoreDataHandler insertManagedObjectOfClass:[Students class] inManagedObjectContext:kAppDelegate.managedObjectContext];
                                 student.name = nameField.text;
                                 student.studentID = studentIDField.text;
                                 [CoreDataHandler saveManagedObjectContext:kAppDelegate.managedObjectContext];
                                 [self readStudentRecord];
                             }
                             else{
                                 NSLog(@"Record not saved. Please enter both student name and student id");
                             }
                            
                             
                             
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"StudentID";
        
    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)deleteAllStudents:(id)sender {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.students count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
     if (cell ==nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
     }
 
     Students *student = self.students[indexPath.row];
     cell.textLabel.text = student.name;
     cell.detailTextLabel.text = student.studentID;
     
     UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
     delete.tag = indexPath.row;
     delete.frame = CGRectMake(200, 5, 80, 40);
     [delete setTitle:@"Delete" forState:UIControlStateNormal];
     [delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [delete addTarget:self action:@selector(deleteHandler:) forControlEvents:UIControlEventTouchUpInside];
     [cell.contentView addSubview:delete];
     
 
 return cell;
 }
 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateRecord];
}

@end
