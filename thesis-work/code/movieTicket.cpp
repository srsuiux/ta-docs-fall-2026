#include <iostream>
using namespace std;

int ticketPriceSundar(int age, bool isStudent) {
    if (age < 0 || age > 120) {
        return -1;
    } else if (age < 12) {
        return 5;
    } else if (age >= 65) {
        return 6;
    } else if (isStudent) {
        return 8;
    } else {
        return 12;
    }
}

/* angello:*/
// terminology: implementation decisions
int ticketPrice(int age, bool isStudent){
    
    if (age < 0 || age > 120) {
        return -1;
    }
    if (age < 12){
        return 5;
    }
    if (age >= 65){
        return 6
    }
    // if previous two if cases are false logically it must true that 
    // age is between 12 and 64 includsive
    if (age >=12 && age <= 64){
        if (isStudent){
            return 8;
        }
        else{
            return 12;
        }
    }

}

int main() {
    int age;
    bool isStudent;
    cout << "Enter age: ";
    cin >> age;
    cout << "Student? (1 = yes, 0 = no): ";
    cin >> isStudent;

    int price = ticketPriceSundar(age, isStudent);

    if (price == -1) {
        cout << "Invalid age entered" << endl;
    } else {
        cout << "Ticket price: $" << price << endl;
    }

    return 0;
}


- raw gpt log- https://chatgpt.com/c/6aeb7e04-138c-83e9-b238-24719eef771f

- we have discusse this problem, and thenn we need to work on thee decisions, factors. 
orders here order matters, and what decisions the student have to own. 
so thinking

- take referenbces fromthe whiteboard we discussed, and all think and run some exoperient against the 
problem we discusssed and make a solild experiemnt. 



