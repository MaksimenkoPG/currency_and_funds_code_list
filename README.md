# Current currency & funds code list with currency symbols
The main source of currencies is https://www.currency-iso.org/en/home/tables/table-a1.html
The source for currency symbols is https://developers.google.com/public-data/docs/canonical/currencies_csv

# How to prepare an environment

- Install RVM https://rvm.io/rvm/install
- Install dependencies for Nokogiri https://nokogiri.org/tutorials/installing_nokogiri.html

```
bundle install
```

# Update currency & funds code list

```
ruby refresh_list.rb
```