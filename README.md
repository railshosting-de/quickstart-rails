# quickstart-rails

Creates a docker based rails app

## How to use this image

1. Create rails app

   ~~~ sh
   mkdir test-app
   docker run -ti --rm -v "$PWD/rails-test":/home/rails railshosting/quickstart-rails new test-app -d mysql
   ~~~

2. Run rails app

   ~~~ sh
   cd test-app
   docker-compose up
   ~~~

4. Open app in browser

   [http://localhost:3000](http://localhost:3000)


## Customization

The meta directory contains docker files that are used to run the application.

~~~ sh
mkdir meta
tar -xf meta.tgz -C ./meta
~~~

After you have made adjustments here you need to update the meta.tgz file and rebuild the image.

~~~ sh
tar cfz meta.tgz -C ./meta .
~~~