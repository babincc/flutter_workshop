# DartGov FBI

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/dart_gov_fbi_demo.png" alt="Three screenshots from the example program." height="400">

Empower your Dart applications with seamless access to critical information from the Federal Bureau of Investigation (FBI) using the DartGov FBI SDK. This powerful software development kit provides developers with a straightforward interface to communicate with the FBI's public APIs, specifically tailored for accessing data on wanted persons and art crimes.

## Installation

In the `pubspec.yaml` of your project, add the following dependency:

```yaml
dependencies:
  dart_gov_fbi: ^0.1.1
```

Import it to each file you use it in:

```dart
import 'package:dart_gov_fbi/dart_gov_fbi.dart';
```

## Usage

The FBI's database can only be accessed in chunks. Rather than dumping the entire thing into your program, you will need to decide how you want to access the information, and what you are looking for.

The database is broken up into pages, which you can access by index (starting at 1). By default, the pages are 50 items in length. That means with 1000 items, the database will have 20 pages.

You can further refine your search by changing the page size, or the number of items per page. Let's say you change the page size to 10 (instead of 50). Now the same database with 1000 items will have 100 pages (instead of 20). The data is the same, what changes is how it is packaged up and sent to you. This means that with a page size of 10, pages 1 - 5 will have the same data as page 1 when using a page size of 50.

Warning: If you try and access their database too many times in a short time span, they will lock you out for a while. Only pull what you need, or risk triggering their CloudFlare lockout.

### Example 1 - Fetching a page of data

This example show a few ways to fetch a single page of data.

```dart
// Fetch page 1 with page size 50
fetchArtCrimes(); // Art crimes
fetchWantedPersons(); // Wanted persons

// Fetch page 3 with page size 50
fetchArtCrimes(page: 3); // Art crimes
fetchWantedPersons(page: 3); // Wanted persons

// Fetch page 3 with page size 25
fetchArtCrimes(page: 3, pageSize: 25); // Art crimes
fetchWantedPersons(page: 3, pageSize: 25); // Wanted persons

// Fetch the last page by reversing the order
fetchArtCrimes(
  sortDirection = ArtCrimeSortDirection.ascending,
);
fetchWantedPersons(
  sortDirection = WantedPersonSortDirection.ascending,
);
```

### Example 2 - Fetch specific item

If you already have the ID of an item you want, you can directly fetch that item from the database.

```dart
fetchArtCrime('artCrimeId_123'); // Art crime
fetchWantedPerson('wantedPersonId_123'); // Wanted person
```

<hr>

<h3 align="center">If you found this helpful, please consider donating. Thanks!</h3>
<p align="center">
  <a href="https://www.buymeacoffee.com/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/buy_me_a_coffee_logo.png" alt="buy me a coffee" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://paypal.me/cssbabin" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/pay_pal_logo.png" alt="paypal" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://venmo.com/u/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/venmo_logo.png" alt="venmo" height="45">
  </a>
</p>
<br><br>
