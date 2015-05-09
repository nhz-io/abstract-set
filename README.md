# abstract-set

## Abstract Set [![Build Status][travis-image]][travis-url]
[![NPM][npm-image]][npm-url]

## Install
```
npm install --save abstract-set
```

## Browser
* [abstract-set.js](abstract-set.js)
* [abstract-set.min.js](abstract-set.min.js)

Build
-----
```
git clone https://github.com/nhz-io/abstract-set.git
cd abstract-set
npm install
gulp
```

VERSION
-------
#### 0.0.5
* changed empty() to call handler method
* added size()

#### 0.0.4
* added toJSON()
* added valueOf()
* fallback to default handler if particular handler is missing

#### 0.0.3
* Total remake

#### 0.0.2
* Remove length property on toJSON when length is 0

LICENSE
-------
#### [MIT](LICENSE)

[travis-image]: https://travis-ci.org/nhz-io/abstract-set.svg
[travis-url]: https://travis-ci.org/nhz-io/abstract-set

[npm-image]: https://nodei.co/npm/abstract-set.png
[npm-url]: https://nodei.co/npm/abstract-set
