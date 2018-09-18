# Alfred

Read my schedule and text me with relevant info.

Triggered by sms.

## Development
```
# build image
docker build -t pamplemousse/alfred .

# run the app
docker run --rm -it \
  -p 8000:9292 \
  pamplemousse/alfred \
  rackup config.ru --host=0.0.0.0
```

## Test
```
# automated tests
docker run \
  -u $(id -u):$(id -g)
  -v $(pwd):/app
  -w /app
  pamplemousse/alfred rspec
```
