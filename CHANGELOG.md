# Changelog

## 0.2.3

* Internet checker now optionally uses a given address to check.

## 0.2.2

* Internet checker now uses the base URL.

## 0.2.1

* Option to wait until internet is connected then send request.

## 0.2.0

* Check the internet status before making a request

## 0.1.1

* Update http library (again)

## 0.1.0

* Downgraded http library back down to prevent conflices with several libraries
* Version is not provided directly in Crash instead of Stupid.crash.

## 0.0.9

* Added optional version to crashes, defaults to "unknown"

## 0.0.8

* Removed timeout (leave that for implementations if they deem it necessary).
* Added `Stupid.onError` for when exceptions are caught.

## 0.0.7

* Updated timeout time from .5 seconds to 5 seconds
