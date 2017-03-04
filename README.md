# Alfred

Read my schedule and text me with relevant info.

## Development
```
# build image
docker build -t pamplemousse/alfred .

# run the tests
docker run pamplemousse/alfred rspec

# run the script
docker run --rm -it \
  -p 8000:9292 \
  pamplemousse/alfred \
  rackup config.ru --host=0.0.0.0
```
