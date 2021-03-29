# Rioc

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rioc`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rioc'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rioc

## Usage

The user experience will be closer to C# Autofac framework. Suppose you want to build a webapp using the repository pattern, here's a typical usecase,

```ruby
# Initialize a container
container = Rioc::RiocContainer.new

# Specify the controller to the IoC container, suppose your controller looks like the following
# 
# class BusinessController
#   def initialize(repository)
#     @repository = repository
#   end
#   
#   def save(text)
#     @repository.save(text)
#   end
# end
# 
# Typically for most web application frameworks, the controller is one instance per request, and it
# would translate to Transient scope in RIOC
container.register(:biz_controller, scope: Rioc::Bean::Scope::TRANSIENT) do |c| 
    BusinessController.new(c.resolve(:repository))
end

# Now you need to have the repository dependency setup so that it can be consumed by the controller
# and typically repository is Singleton as in Guice or Spring in Java. Suppose the repository looks
# like this
# 
# class Repository
#   def initialize(credential)
#     @credential = credential
#   end
# end
#
# And RIOC uses Singleton scope by default.
container.register(:repository) { |c| Repository.new(c.resolve(:credential)) }

# Now register the credential, let's assume the credential is an parameterless object
container.register(:credential) { |_| Credential.create("username", "password") }

# Build container
container.build_container

# Now we have all dependencies we need registered into the container, we can use them by
biz_con = container.resolve(:biz_controller)
biz_con.save("Hello RIOC")

# Of course you can also resolve repository and credential
repo = container.resolve(:repository)
cred = container.resolve(:credential)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rioc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rioc/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rioc project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rioc/blob/master/CODE_OF_CONDUCT.md).
