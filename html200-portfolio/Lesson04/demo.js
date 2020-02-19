function numberAdder(firstNumber) {
  let input = prompt('Enter a number');
  let numberToAdd = 2;
  let result = 0;

  result = numberToAdd + Number(input); //if one of the vars is a String, js will assume concatenation. Use number
  //conversion

  alert(result);

}
