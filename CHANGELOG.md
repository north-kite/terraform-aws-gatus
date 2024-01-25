# Changelog

## [1.1.0](https://github.com/north-kite/terraform-aws-gatus/compare/v1.0.2...v1.1.0) (2024-01-25)


### Features

* if listener protocol is HTTPS, then create redirect from HTTP to HTTPS ([b2029c4](https://github.com/north-kite/terraform-aws-gatus/commit/b2029c451520710ace80c56e3ae2c5d0c9e4f806))
* use `/health` path for health checks ([7d107d4](https://github.com/north-kite/terraform-aws-gatus/commit/7d107d4805a4a442c3531baf63a2617d99d30fee))

## [1.0.2](https://github.com/north-kite/terraform-aws-gatus/compare/v1.0.1...v1.0.2) (2024-01-25)


### Bug Fixes

* correct protocol between ALB and app ([f030623](https://github.com/north-kite/terraform-aws-gatus/commit/f030623fc77194d6686a3436c23adf1b83a50717))

## 1.0.0 (2024-01-18)


### Features

* allow setting extra env vars on container ([a3ca23a](https://github.com/north-kite/terraform-aws-gatus/commit/a3ca23a68f32df5dd127711db0d5d9afe14fe258))
* **examples:** add building image with config to examples ([d6aa601](https://github.com/north-kite/terraform-aws-gatus/commit/d6aa6017db4c6920359477675cb4d2cc2f290aca))
* output DNS name of load balancer ([469f5cd](https://github.com/north-kite/terraform-aws-gatus/commit/469f5cd7425f9381503ed282c0dc8bd7367a1675))
