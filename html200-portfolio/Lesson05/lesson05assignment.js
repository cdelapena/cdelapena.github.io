function bank() {

//initialize variables
const deposit_cap = 50000;
const low_balance = 300;
let withdrawal = 0;
let deposit = 0;
let balance = 0;
let entry = 0;
let input = 0;
var deposit_check = 0;
var confirmation = '';

//prompt user using dialog box
//ensure there are 4 options: Q, W, D, B
balance = prompt('Input your bank balance in dollars without the $ sign');
//check for legitimate balance entry
  while (isNaN(balance) || balance > deposit_cap) {
    alert('Not a valid entry');
    //don't declare with let inside while loop
    balance = prompt('Input your bank balance in dollars without the $ sign');
  }
  //ensure user input is converted to numbers;
  balance = parseInt(balance);
entry = prompt('Select from the choices: Q to quit, W to withdraw, D to deposit or B to view balance');

//convert input to uppercase
input = entry.toUpperCase();
//have default command for options outside of scope.
while (input != 'Q') {
  if (balance <= low_balance) {
    alert('You have a low balance(less than $300)');
    }
  switch (input) {
    case 'W': {
      if (balance <= low_balance) {
        confirmation = prompt('You have a low balance(less than $300). Do you want to proceed? Type Y for yes and N for no');
        confirmation_upper = confirmation.toUpperCase();
        if (confirmation_upper == 'N') {
          break;
        } else if (confirmation_upper == 'Y') {
            withdrawal = prompt('Enter amount to withdraw');
            while (isNaN(withdrawal)) {
              alert('Not a valid entry');
              withdrawal = prompt('Enter an integer amount to withdraw');
            }
            withdrawal = parseInt(withdrawal);
            if ((balance - withdrawal) < 0) {
              alert('Cannot have less than $0');
              withdrawal = 0;
            } else {
          balance = balance - withdrawal;
          }
        } else {
          confirmation = prompt('Not a valid entry. You have a low balance(less than $300). Do you want to proceed? Type Y for yes and N for no');
        }
        }
      break;
    }
    case 'D': {
      deposit = prompt('Enter amount to deposit');
      while (isNaN(deposit)) {
        alert('Not a valid entry');
        //Do not redeclare using let
        deposit = prompt('Enter an integer amount to deposit');
      }
      deposit = parseInt(deposit);
      if ( (balance + deposit) > deposit_cap) {
        alert('Cannot have more than $50,000');
        deposit = 0;
      } else {
        balance = balance + deposit;
      }
      break;
    }
    case 'B': {
      alert('Your balance is $' + balance);
      break;
    }
    default: {
      return 'not a valid entry';
    }
  }
  //get new entry
  entry = prompt('Select from the choices: Q to quit, W to withdraw, D to deposit or B to view balance');
  //capitalize entry and turn to new input
  input = entry.toUpperCase();
}
alert('Goodbye!');
}
