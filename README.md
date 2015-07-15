# pokie
little sinatra API testing tool. Very brittle.

### installation

clone the repo: `git clone git@github.com:jugglinghobo/pokie.git`

when `cd`'ing into the `/pokie` directory, rvm should automatically change ruby version and create a gemset.
If you don't have this ruby version installed, you can do so with `rvm install <ruby version>`.
You can also remove `.ruby-version` and `.ruby-gemset` and create a gemset manually.

install gems: `bundle` (if bundler not available: `gem install bundler`)

### usage
You can run the app with `ruby app.rb`, and open http://localhost:4567 to see the interface.

On the left side, you can load existing configurations, or manually enter your own.
On submit, a JSON request will be made according to your parameters.
The result of this request will be displayed on the right side.

__Currently, there's no error handling.__
If something goes wrong, click the back button and adjust your parameters.
