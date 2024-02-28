Specify your private key in .env:
```
cp .env.sample .env

WALLET_PRIVATE_KEY=`your key in base58 format`
```

Build and run dettached Docker Container:
```
docker compose up -d
```

Run specs:
```
docker compose run app bundle exec rspec
```

