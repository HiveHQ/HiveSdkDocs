# Hive SDK Docs using [Slate](https://lord.github.io/slate/#introduction)

Getting Started with Slate
------------------------------

```sh
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby-2.4.1
rvm alias create default 2.4.1
rvm use 2.4.1
git clone https://github.com/HiveHQ/slate.git
cd slate
bundle install
bundle exec middleman server
```

You can now see the docs at http://localhost:4567. Whoa! That was fast!

Edit `index.html.md` to modify docs

`bundle exec middleman build --clean` to build docs

If you'd prefer to use Docker, instructions are available [in the wiki](https://github.com/lord/slate/wiki/Docker).
