App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load books.
    $.getJSON('../books.json', function(data) {
      var booksRow = $('#booksRow');
      var bookTemplate = $('#bookTemplate');

      for (i = 0; i < data.length; i ++) {
        bookTemplate.find('.panel-title').text(data[i].author);
        bookTemplate.find('img').attr('src', data[i].picture);
        bookTemplate.find('.book-title').text(data[i].booktitle);
        bookTemplate.find('.book-publisher').text(data[i].publisher);
        bookTemplate.find('.book-year').text(data[i].year);
        bookTemplate.find('.book-isbn').text(data[i].isbn);
        bookTemplate.find('.btn-add').attr('data-id', data[i].id);

        booksRow.append(bookTemplate.html());
      }
    });

    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there is an injected web3 instance?
    if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
    } else {
        // If no injected web3 instance is detected, fallback to the TestRPC
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Library.json', function(data) {
        // Get the necessary contract artifact file and instantiate it with trufle-contract
        var LibraryArtifact = data;
        App.contracts.Library = TruffleContract(LibraryArtifact);

        // Set the provider for our contracts
        App.contracts.Library.setProvider(App.web3Provider);

        // Use our contract to retrieve and mark the added books
        return App.markAdded();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-add', App.handleAdd);
  },

  markAdded: function(cntBook) {
    var LibraryInstance;

    App.contracts.Library.deployed().then(function(instance) {
        LibraryInstance = instance;

        return LibraryInstance.getCntBook.call();
    }).then(function(cntBook) {
        for (i = 0; i < cntBook; i++) {
            $('.panel-book').eq(i).find('button').text('Success').attr('disabled', true);
        }
    }).catch(function(err) {
        console.log(err.message);
    });
  },

  handleAdd: function(event) {
    event.preventDefault();

    var bookId = ($(event.target).data('id'));
    console.log(bookId);

    var LibraryInstance;

    App.contracts.Library.deployed().then(function(instance) {
        LibraryInstance = instance;

        // Excute addBook as a transaction by sending account
        return LibraryInstance.addBook(bookId);
    }).then(function(result) {
        return App.markAdded();
    }).catch(function(err){
        console.log(err.message);
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
