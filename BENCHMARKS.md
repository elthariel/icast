== iCast API Benchmarks

=== Setup1

On my laptop (i5 4x2.6GHz, 8Gb RAM), with 3500 stations.
* puma (16 threads), ruby 2.0.0p247, pg:pool = 5
  * ab -n 500 -c 2 http://api.lvh.me:3000/1/stations.json
    * 10.78 req/sec
  * ab -n 500 -c 16 http://api.lvh.me:3000/1/stations.json
    * 10.56 req/s
* puma (16 threads), jruby 1.7.4 (1.9.3p392)
  * ab -n 500 -c 16 http://api.lvh.me:3000/1/stations.json
    * (COLD) 14.3 req/s
    * (WARM) ~ 24 req/s
  * ab -n 1000 -c 32 http://api.lvh.me:3000/1/stations.json
    * (WARM) ~ 24 req/s

* puma (16 threads), rbx-2.7.x
  * ab -n 1000 -c 16 http://api.lvh.me:3000/1/stations.json
    * (WARM) ~ 14 req/s

=== Setup2

Same as above, but genre_list serialization is disabled

* puma (16 threads), ruby 2.0.0p247
  * ab -n 1000 -c 4 http://api.lvh.me:3000/1/stations.json
    * ~ 32 req/s
  * ab -n 1000 -c 16 http://api.lvh.me:3000/1/stations.json
    * ~ 31 req/s
* unicorn (default config), ruby 2.0.0p247
  * ab -n 1000 -c 16 http://api.lvh.me:3000/1/stations.json
    * ~ 32.5 req/s

* puma (16 threads), rbx-2.7.x
  * ab -n 1000 -c 16 http://api.lvh.me:3000/1/stations.json
    * (WARM) ~ 42 req/s
* puma (16 threads), jruby-1.7.4
  * ab -n 1000 -c 16 http://api.lvh.me:3000/1/stations.json
    * (COLD) ~ 25 req/s
    * (WARM) ~ 58 req/s
  * ab -n 1000 -c 4 http://api.lvh.me:3000/1/stations.json
    * (WARM) ~ 60 req/s
