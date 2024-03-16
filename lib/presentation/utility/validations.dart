String? emailValidation(String? value){
  if(value == null || value.trim().isEmpty) {
    return 'Enter email';
  }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value.trim())){
    return 'Invalid email format';
  }
  return null;
}

String? passwordValidation(String? value){
  if(value == null || value.trim().isEmpty) {
    return 'Enter password';
  }else if(value.trim().length<8){
    return 'Minimum 8 characters';
  }
  return null;
}

String? mobileValidation(String? value){
  if(value == null || value.trim().isEmpty) {
    return 'Enter mobile no.';
  }else if(value.trim().length<11){
    return 'Minimum 11 characters';
  }
  return null;
}


String? normalValidation(String? value,String fieldName){
  if(value == null || value.trim().isEmpty) {
    return 'Enter $fieldName';
  }
  return null;
}



