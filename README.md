# Alfred

Read my schedule and text me with relevant info.

## Development
```
# build image
docker build -t pamplemousse/alfred .

# run the tests
docker run pamplemousse/alfred bundle exec rspec

# run the script
docker run --rm -it \
  pamplemousse/alfred \
  ruby main.rb
```
