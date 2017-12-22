pragma solidity ^0.4.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Library.sol";


contract TestLibrary {
    Library mylib = Library(DeployedAddresses.Library());

    uint160[10] accounts = [
        0x627306090abab3a6e1400e9345bc60c78a8bef57,
        0xf17f52151ebef6c7334fad080c5704d77216b732,
        0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef,
        0x821aea9a577a9b44299b9c15c88cf3087f3b5544,
        0x0d1d4e623d10f9fba5db95830f7d3839406c6af2,
        0x2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e,
        0x2191ef87e392377ec08e7c08eb105ef5448eced5,
        0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5,
        0x6330a553fc93768f612722bb8c2ec78ac90b3bbc,
        0x5aeda56215b167893e80b4fe645ba6d5bab767de
    ];

    uint168[10] tempHash = [
        accounts[0]+0,
        accounts[0]+1,
        accounts[0]+2,
        accounts[0]+3,
        accounts[0]+4,
        accounts[0]+5,
        accounts[1]+6,
        accounts[2]+7,
        accounts[3]+8,
        accounts[4]+9
    ];

    function testConstructor() public {
        mylib.addBook(tempHash[0]);
        Assert.equal(mylib.getOwner(tempHash[0]), this, "owner is same with msg.sender should be recorded.");
    }

    function testConstructor2() public {
        mylib.addBook(tempHash[1]);
        Assert.equal(mylib.getOwner(tempHash[1]), this, "owner is same with msg.sender should be recorded.");
    }

    function testDelete() public {
        mylib.deleteBook(tempHash[0]);
        mylib.deleteBook(tempHash[1]);
        Assert.equal(mylib.getOwner(tempHash[1]), 0, "owner is same with msg.sender should be recorded.");
    }

    function testDelete2() public {
        mylib.addBook(tempHash[2]);
        mylib.deleteBook(tempHash[2]);
        Assert.equal(mylib.getOwner(tempHash[2]), 0, "owner is same with msg.sender should be recorded.");
    }

    function testGetCntBook() public {
        mylib.addBook(tempHash[0]);
        Assert.equal(mylib.getCntBook(), 1, "");
    }

    function testBorrow() public payable {
        mylib.borrow(tempHash[0]);
        Assert.equal(mylib.getUser(tempHash[0]), this, "");
        Assert.equal(mylib.getBalance(tempHash[0]), 0 ether, "");
    }

    function testCheckOut() public {
        mylib.checkOut(tempHash[0]);
        Assert.equal(mylib.getUser(tempHash[0]), 0, "");
        Assert.equal(mylib.getOwner(tempHash[0]), this, "");
        Assert.equal(mylib.getBalance(tempHash[0]), 0 ether, "");

    }


}
