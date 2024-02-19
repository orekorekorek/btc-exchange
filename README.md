Specify your private key in .env:
```
cp .env.sample .env
```

Build and run dettached Docker Container:
```
docker compose up -d
```

Run specs:
```
docker compose run app bundle exec rspec
```

