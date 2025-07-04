# Hive SDK Docs using [Slate](https://lord.github.io/slate/#introduction)

## Getting Started

### Docker (recommended)

```sh
docker compose up -d
```

### Local

```sh
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby-2.4.1
rvm alias create default 2.4.1
rvm use 2.4.1
git clone https://github.com/HiveHQ/HiveSdkDocs.git
cd HiveSdkDocs
gem install bundler
bundle install
bundle exec middleman server
```

You can now see the docs at http://localhost:4567. Whoa! That was fast!

Edit `index.html.md` to modify docs

## Deployment

Push changes to remote then ssh into blog server.

Please note that to SSH in, you will need to add your IP address (eg. 1.2.3.4/32 tcp port 22) into the ingress rules for the EC2 instance's security group.

Security Group ID and name: sg-98203ffc - launch-wizard-4
EC2 instance ID and name: i-043f38d4 (blog/sdk docs)

Pull the changes and run:

```sh
cd HiveSdkDocs
bundle exec middleman build --clean
```

That's it, nginx will serve the updated docs.
