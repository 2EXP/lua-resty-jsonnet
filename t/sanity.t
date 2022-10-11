# vim:set ft= ts=4 sw=4 et fdm=marker:

use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
  lua_package_path "$pwd/lib/?.lua;;";

  init_worker_by_lua_block {
    local jsonnet = require "resty.jsonnet"
    jsonnet.init()
  }
};

run_tests();

__DATA__

=== TEST 1: jsonnet_evaluate_snippet
--- http_config eval: $::HttpConfig
--- config
location /t {
  content_by_lua_block {
    local jsonnet = require "resty.jsonnet"

    local jsonnet_snippet = '{ x: 1 , y: self.x + 1 } { x: 10 }'
    local json, err = jsonnet.evaluate_snippet("snippet", jsonnet_snippet)
    ngx.say(json)
  }
}
--- request
GET /t
--- response_body
{
    "x": 10,
    "y": 11
}
