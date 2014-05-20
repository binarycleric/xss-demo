# XSS Demo

This is a simple Rack application that's meant to demonstrate a few XSS attack examples. More examples will be added whenever I feel like it. Have an example you'd like to share? Feel free to submit a Pull Request.

## Getting Started

```bash
$ cd ~/src/xss-demo
$ bundle install
$ bundle exec rackup
```

Now open your browser and go to `http://0:9292`.

## XSS Demo Server

A seperate repo has been created to emulate an attacker's endpoints. This repo can be found at [binarycleric/xss-demo-server](https://github.com/binarycleric/xss-demo-server). New features and pull requests are welcome.

## A Note on Browsers

Chrome seems to have some built-in XSS protections. I'm still learning about how all this works so in the meantime consider using Firefox when messing with this application. Explanations/PRs to make Chrome ignore XSS attempts are more than welcome.

## Further Reading

* https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
* https://www.owasp.org/index.php/Types_of_Cross-Site_Scripting
* https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet
