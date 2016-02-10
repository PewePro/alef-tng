# ALEF: The Next Generation

ALEF: TNG is a learning system.

## TNG?
This is _T_he _N_ext _G_eneration of original ALEF.

## Requirements

* Ruby 2.2
* Bundler
* PostgreSQL 9.3

## Installation

Clone and install gems.

```
git clone git@github.com:PewePro/alef-tng.git
cd alef-tng
bundle install
```

Edit configuration file(s).

```
cp config/database.yml.example config/database.yml
vim config/database.yml
```

Create the database.

```
rake db:create && rake db:migrate
```

Optionally, seed the database with setups and import your question data.

```
rake db:seed
rake alef:data:import_csv['evaluator_questions.csv','choice_questions.csv','pics_dir']
```

## Testing

!TODO!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin new-feature`)
5. Create new Pull Request

## License

!TODO!
