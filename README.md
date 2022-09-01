# Ruby RTI Example

[![codecov](https://codecov.io/gh/codecov/impact-analysis-example-ruby/branch/main/graph/badge.svg)](https://codecov.io/gh/codecov/impact-analysis-example-ruby)

This repository demonstrating how to use Codecov's [Impact Analysis](https://about.codecov.io/product/feature/impact-analysis/) feature with ruby. It runs with the [Rails](https://rubyonrails.org/) framework and leverages the [codecov/opentelem-ruby](https://github.com/codecov/opentelem-ruby) package to send information to Codecov's Runtime Insights API.

This repository is set up to do to be used as
1. a working sandbox to explore Impact Analysis
1. a reference for adding Impact Analysis to your own repositories

## Getting Started

The following section details how to get started with Impact Analysis. Before getting started, you will need
1. `ruby` version 3+
2. An account on [Codecov](https://about.codecov.com)

<br />

**Step 1: Fork and clone this repository**
-------------

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) this repository from GitHub. It is strongly recommended that you fork the repository to your personal GitHub account.
Clone your new repository to your local machine.

<br />

**Step 2: Set the `profiling token`**
-------------

Go to [Codecov](https://app.codecov.io/gh) and find the fork in the list of repositories. Note that it may be under `Not yet setup` in the right-hand section.

In the `settings` page, grab the `Impact analysis token`, and set the token locally in a terminal.
```
export CODECOV_OPENTELEMETRY_TOKEN='***'
```

<br />

**Step 3: Install the dependencies**
-------------

Install all dependencies for this project.
```
bundle install
```

<br />

**Step 4: Run the server locally and generate profiling data**
-------------

Run the server from your machine using the command
```
./bin/rails server
```
If the token has been set properly, you should see the server running with the following logs
```
=> Booting Puma
=> Rails 7.0.3.1 application starting in development
=> Run `bin/rails server --help` for more startup options
...
Puma starting in single mode...
* Puma version: 5.6.4 (ruby 3.1.2-p20) ("Birdie's Version")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 95097
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

You can view the app by going to `http://127.0.0.1:3000/`.
The app has two pages, the main page that has a button to `Get the time`, while the other page displays the time.

<br />

**Step 5: Overloading the `/time` endpoint**
-------------

In order for us to see what happens when we change a critical (frequently hit) line, we will need to hit the `/time` endpoint. In a python shell, run the following with the server running
```
import requests

for i in range(1000):
    print(i)
    requests.get('http://127.0.0.1:3000/time')
```
This should hit our `/time` endpoint 1000 times and upload the telemetry data to Codecov.

You may need to wait an hour or two before continuing to the next step for the profiling data to be processed by Codecov.

<br />

**Step 6: Making a change to critical code**
-------------

Let's now make a change in our code to see if what we are changing is critical.

In `app/helpers/timer_helper.rb`, update line 7 from
```
    time.strftime('%Y-%m-%d:%H:%M:%S')
```
to
```
    time.strftime('%Y-%m-%d::%H:%M:%S')
```


You will also need to update the tests. Change line 7 of `spec/helpers/timer_helper_spec`
```
      expect(helper.format_time(current_time)).to eql(current_time.strftime('%Y-%m-%d:%H:%M:%S'))
```
to
```
      expect(helper.format_time(current_time)).to eql(current_time.strftime('%Y-%m-%d::%H:%M:%S'))
```

Save the changes, create a new branch, and push to GitHub.
```
git checkout -b 'test-codecov'
git add example-app/
git commit -m 'fix: update time display with colon'
git push origin test-codecov
```
Open a new pull request. Be sure to set the base branch to your fork.

<br />

**Step 7: Seeing Impact Analysis in the UI**
-------------

After CI/CD has completed, you should see a comment from Codecov similar to this [PR](https://github.com/codecov/impact-analysis-example-ruby/pull/23). The comment will now show 2 new elements

1. Under `impacted files`, you should see a `Critical` label next to `app/helpers/timer_helper.rb`. This means that the PR has a change in that file that is frequently hit in production.
2. Under `related entrypoints`, you should see `action_view render_template`. This means that the PR has a change that touches that endpoint.

You should now be able to see how Impact Analysis can give crucial information on how a code change can affect critical code in your system.

### Troubleshooting
------------
You may need to add profiling fixes to your application. You can do this in the `codecov.yml` file under `profiling -> fixes`. We recommend finding the full path of the environment that is sending telemetry data (e.g. local or CI) and using the portion from the beginning to the repository name on the left side of the fixes.

For example, if running locally, the full path might be

```
/Users/localuser/src/github/codecov/impact-analysis-example-ruby/...
```

The `codecov.yml` should add the following
```
profiling:
  fixes:
    - "/Users/localuser/src/github/codecov/impact-analysis-example-ruby::"
```

### Using your own repositories
To get started with Impact Analysis on your own repositories, check out our getting started [guide](https://docs.codecov.com/docs/impact-analysis-quickstart-ruby).
