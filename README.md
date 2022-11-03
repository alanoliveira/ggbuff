# ⚠️⚠️⚠️ IMPORTANT ⚠️⚠️⚠️

**THIS IS A FAN MADE APP, IT IS NOT RELATED AT ALL WITH ARC SYSTEM WORKS.**

# GG Buff

GG Buff is a statistical tool for GGXRD Rev2 Arcade matches data.  
It conver some missing functionallities from the [official app](http://www.ggxrd.com/pg2/index.php), like:
- How many matches I have with a certain player what is the victory rate
- Who is the player I have most matches with
- Who is my greatest tormentor

![image](https://user-images.githubusercontent.com/6012864/177037467-d20602b7-b3b7-4cd3-b7de-9fddf5c531bd.png)

## Dependencies
- Ruby 2.7.6
- Bundler 2.1.4
- NodeJs 16.3.1
- Yarn 1.22.19
- Postgresql 14

## Building

```
export DATABASE_URL="postgres://user:password@host"
bundle install
bin/rails db:{create,migrate,seed}
yarn install
bin/rails webpacker:compile
```

## Status

[![alanoliveira](https://circleci.com/gh/alanoliveira/ggbuff.svg?style=shield)](https://app.circleci.com/pipelines/github/alanoliveira/ggbuff)
