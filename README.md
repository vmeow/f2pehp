![F2P Wiki Banner Logo](app/assets/images/f2pwiki_500.png)

# F2P.wiki

F2P.wiki is an open source Old School RuneScape hiscores for Free-to-play players. 

## Contributing

We are happy to receive any and all help!

* Developers (Ruby, Rails, HTML/CSS/JavaScript)
* Open source experts
* Project owners
* Content managers (FAQs, links, etc.)

Feel free to look at our [TODO](TODO.md) list for any ideas.

To contribute a code change, please create a separate branch and submit a pull request.

## Install and setup

### 1. Install Git, Ruby, and Bundler

Make sure to install Ruby 2.6.3

#### Windows

* Git - [https://gitforwindows.org/](https://gitforwindows.org/)
* Ruby - [https://rubyinstaller.org/](https://rubyinstaller.org/)
* Bundler

```bash
gem install bundler
```

#### Mac

* Git - [https://sourceforge.net/projects/git-osx-installer/files/](https://sourceforge.net/projects/git-osx-installer/files/)
* Ruby - [http://railsinstaller.org/en](http://railsinstaller.org/en)
* Bundler

```bash
gem install bundler
```

#### Linux

Update the packages first using

```bash
sudo apt update
```

* Git

```bash
sudo apt-get install git
```

* Ruby

```bash
sudo apt install ruby-full
```

* Bundler

```bash
gem install bundler
```

### 2. Verify installation

```bash
git --version
```

```bash
ruby --version
```

```bash
bundler --version
```

### 3. Fork or clone the repository

```bash
git clone https://github.com/vmeow/f2pehp.git
```

Setting push origin to forked repo

```bash
git remote set-url origin --push https://github.com/USERNAME/f2pehp.git
```

### 4. Install ruby gems

```bash
bundle install
```

### 5. Run database migrations

```bash
bundle exec rake db:migrate
```

### 6. Verify installation by running server

```bash
rails s
```

The app should now be running at [http://localhost:3000](http://localhost:3000) or [127.0.0.1:3000](127.0.0.1:3000).

## Useful Links

Rails Command Line - [https://guides.rubyonrails.org/command_line.html](https://guides.rubyonrails.org/command_line.html)

Bundler Commands - [https://bundler.io/v2.0/commands.html](https://bundler.io/v2.0/commands.html)

## License

MIT © F2P.wiki
