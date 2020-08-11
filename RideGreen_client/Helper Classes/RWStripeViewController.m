//
//  RWPaymentViewController.m
//  RWPuppies
//
//  Created by Pietro Rea on 12/25/12.
//  Copyright (c) 2012 Pietro Rea. All rights reserved.
//

#import "RWStripeViewController.h"
//#define STRIPE_TEST_PUBLIC_KEY @"pk_live_Q0LnMFB0tWxTDCR9slOsau5U"


@interface RWStripeViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
{
    AppDelegate  *delg;
    NSUserDefaults *prefs;
    NSMutableData* _receivedDataNew;
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;

@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;


@property (strong, nonatomic) STPCard* stripeCard;


@end

@implementation RWStripeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
	// Do any additional setup after loading the view.
    registerView =[[RegisterViewController alloc] init];
    self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
    @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
    @"10 - October", @"11 - November", @"12 - December"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender {
   
    //1
 
//       delg.clientName = @"syed";
//       delg.ClientEmail = @"syed.shah@gmail.com";
    [self.nameTextField setText: delg.clientName];
    
    [self.emailTextField setText: delg.ClientEmail];
    //NSLog(@"self.nameTextField.text %@ self.emailTextField.text %@",delg.clientName,delg.ClientEmail);
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = delg.clientName;
    self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    
    //2
    if ([self validateCustomerInfo])
    {
        [self performStripeOperation];
    }
    
    
    
}

- (BOOL)validateCustomerInfo {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //1. Validate name & email
    if (delg.clientName.length == 0 ||
        delg.ClientEmail.length == 0) {
        
        [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)performStripeOperation {
    //1
    self.completeButton.enabled = NO;
    //NSLog(@"self.stripeCard %@",self.stripeCard);
    MBProgressHUD *hude=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hude.labelText=@"Verifying Credit Card..";
    //2
    
    [Stripe createTokenWithCard:self.stripeCard
                 publishableKey:STRIPE_TEST_PUBLIC_KEY
                     completion:^(STPToken* token, NSError* error) {
                         if(error)
                         {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [self handleStripeError:error];
                            NSLog(@"error %@",error);
                         }
                         else
                         {
                             //Add Token in DB
                             NSLog(@"token %@",token.tokenId);
                             delg.cardTokenId = token.tokenId;
                             NSLog(@"token %@",delg.cardTokenId);
                             prefs = [NSUserDefaults standardUserDefaults];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [prefs setObject:token.tokenId forKey:@"token_id"];
                             delg.isgotToken = YES;
                             
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                    message:@"Credit Card Verified"
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                         [alert show];
                             
                             
                             [self.delegate expirationDate:self.expirationDateTextField.text CardNumber:self.cardNumber.text];
                             
                             [self.navigationController popViewControllerAnimated:YES];

                         }
                         
                     }];
}


- (void)postStripeToken:(NSString* )token {
    //1
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
//     [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    NSInteger totalCents = [delg.finalFare integerValue] * 100;
//    //3
//    NSMutableDictionary* postRequestDictionary = [[NSMutableDictionary alloc] init];
//    postRequestDictionary[@"stripeAmount"] = [NSString stringWithFormat:@"%ld", (long)totalCents ];
//    postRequestDictionary[@"stripeCurrency"] = @"usd";
//    postRequestDictionary[@"stripeToken"] = token;
//    postRequestDictionary[@"stripeDescription"] = @"Purchase";
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    [stripUrl appendString:Kregister_stripe_url];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeToken=%@&stripeEmail=%@",delg.cardTokenId,delg.ClientEmail]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
     self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                           
    {
        [self chargeDidSucceed];
        
    }
      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"%@",JSON);
        NSLog(@"error %@",error);
        [self chargeDidNotSuceed];
    }];
    
    [self.httpOperation start];
    
    self.completeButton.enabled = YES;

}

- (void)handleStripeError:(NSError *) error {
    //1
    if ([error.domain isEqualToString:@"StripeDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.completeButton.enabled = YES;
}

- (void)chargeDidSucceed {
    //1
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Fare has been Paid"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
  //  RWCheckoutCart* checkoutCart = [RWCheckoutCart sharedInstance];
  //  [checkoutCart clearCart];
    
   
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)chargeDidNotSuceed {
    //2
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

/* The methods below implement the user interface. You don't need to change anything. */

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // (1) user details, (2) credit card details
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 70;
    }
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,10, self.tableView.frame.size.width, 30)] autorelease];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor =[UIColor whiteColor];
        lbl.text = @"Customer Info";
        lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        return lbl;
    }
    return nil;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
//    if (section == 0 && row == 0) {
//        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
//        cell.nameLabel.text = @"Name";
//        cell.textField.placeholder = @"Required";
//        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
//        self.nameTextField = cell.textField;
//        return cell;
//    }
//    else if (section == 0 && row == 1) {
//        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
//        cell.nameLabel.text = @"E-mail";
//        cell.textField.placeholder = @"Required";
//        self.emailTextField = cell.textField;
//        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
//        return cell;
//    }
    if (section == 0 && row == 0) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Card Number";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.keyboardAppearance = UIKeyboardAppearanceDark;
        self.cardNumber = cell.textField;
        return cell;
    }
    else if (section == 0 && row == 1) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Exp. Date";
        cell.textField.text = @"Required";
        cell.textField.textColor = [UIColor lightGrayColor];
        cell.textField.keyboardAppearance = UIKeyboardAppearanceDark;
        self.expirationDateTextField = cell.textField;
        return cell;
    }
    else if (section == 0 && row == 2) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"CVC Number";
        cell.textField.placeholder = @"Required";
        self.CVCNumber = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.keyboardAppearance = UIKeyboardAppearanceDark;
        [self configurePickerView];
        return cell;
    }
    
    return nil;
}
#pragma mark NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@" Response recieved  NOW ");
    
    if (_receivedDataNew == NULL)
    {
        _receivedDataNew = [[NSMutableData alloc] init];
    }
    //[_receivedDataNew setLength:0];
    // NSLog(@"didReceiveResponse: responseData length:(%d)", _receivedDataNew.length);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"_receivedDataNew %@",_receivedDataNew);
    [_receivedDataNew appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    
}

#pragma mark UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"here we are");
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    
    return YES;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        //Expiration month
        return self.monthArray[row];
    }
    else {
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%zd",(int)currentYear + row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectedMonth = @(row + 1);
    }
    else {
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:row forComponent:1];
        self.selectedYear = @([yearString integerValue]);
    }
    
    
    if (!self.selectedMonth) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        self.selectedMonth = @(1); //Default to January if no selection
    }
    
    if (!self.selectedYear) {
        [self.expirationDatePicker selectRow:0 inComponent:1 animated:YES];
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:0 forComponent:1];
        self.selectedYear = @([yearString integerValue]); //Default to current year if no selection
    }
    
    self.expirationDateTextField.text = [NSString stringWithFormat:@"%@/%@", self.selectedMonth, self.selectedYear];
    self.expirationDateTextField.textColor = [UIColor whiteColor];
}

#pragma mark - UIPicker configuration

- (void)configurePickerView {
    self.expirationDatePicker = [[UIPickerView alloc] init];
    self.expirationDatePicker.delegate = self;
    self.expirationDatePicker.dataSource = self;
    self.expirationDatePicker.showsSelectionIndicator = YES;
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    self.expirationDateTextField.inputView = self.expirationDatePicker;
    self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.emailTextField.inputAccessoryView = pickerToolbar;
    self.cardNumber.inputAccessoryView = pickerToolbar;
    self.CVCNumber.inputAccessoryView = pickerToolbar;
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [_bckBtn release];
    [super dealloc];
}
- (IBAction)bckBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
