pragma solidity ^0.4.0;


contract Library {
    struct BookInfo {
        address owner;  // 도서 소유자
        address user;   // 도서 이용자
        uint balance;   // 도서 예치금
        uint due;       // 반납 예정일

        /*
        *   deleteBook method cause out of gas problem
        *   so we need to refactoring that logic more simple
        *   how about using just state flag?
        *   enum [NOTING, ADDED, BORROWED, DELAYED]
        */
    }

    // 전체 도서 목록
    // bookHash라는 식별자를 통해 개별 도서 정보에 접근
    // bookHash는 소유자 계좌 주소와 local id로 해쉬하여 생성
    // local id는 MongoDB ObjectID로 12 byte 값이다
    mapping (uint => BookInfo) bookList;
    uint cntBook;

    function addBook(uint bookHash) public {
        require(bookList[bookHash].owner == 0);
        bookList[bookHash].owner = msg.sender;
        cntBook++;
    }

    function deleteBook(uint bookHash) public {
        require(bookList[bookHash].user == 0);
        require(bookList[bookHash].owner == msg.sender);
        delete bookList[bookHash];
        cntBook--;
    }

    function borrow(uint bookHash) public payable {
        require(bookList[bookHash].user == 0);
        bookList[bookHash].user = msg.sender;
        bookList[bookHash].balance = msg.value;
        bookList[bookHash].due = now + 10 days;
    }

    function checkOut(uint bookHash) public {
        require(bookList[bookHash].user == msg.sender);
        bookList[bookHash].user.transfer(bookList[bookHash].balance);
        bookList[bookHash].balance = 0;
        bookList[bookHash].due = 0;
        bookList[bookHash].user = 0;
    }

    function getOwner(uint bookHash) constant public returns(address) {
        return bookList[bookHash].owner;
    }

    function getUser(uint bookHash) constant public returns(address) {
        return bookList[bookHash].user;
    }

    function getBalance(uint bookHash) constant public returns(uint) {
        return bookList[bookHash].balance;
    }

    function getDue(uint bookHash) constant public returns(uint) {
        uint tt = bookList[bookHash].due;
        if(tt==0) return tt;
        else {
            if(((tt-now) % 1 days) == 0)
                return ((tt-now) / 1 days);
            else return (((tt-now) / 1 days) + 1);
        }
    }

    function getCntBook() constant public returns(uint) {
        return cntBook;
    }
}
