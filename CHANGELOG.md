# Change Log

All notable changes will be documented in this file in accordance with
[![keepachangelog 1.0.0](https://img.shields.io/badge/keepachangelog-1.0.0-brightgreen.svg)](http://keepachangelog.com/en/1.0.0/)

## \[Unreleased]

## \[2.0.0] - 2024-05-27

### Added

- Ability to push built image to remote repositories via `isPushEnabled` and `namesCsv` inputs
- Support for building multi-platform images via `platformsCsv` input

### Changed

- `cacheDir` renamed to `cache` for consistency

## \[1.3.0] - 2024-05-27

### Updated

- Avoid unnecessary intermediate tar/untar of OCI Image Layout

## \[1.2.0] - 2020-11-17

### Added

- Support passing creds for multiple registries

## \[1.1.1] - 2020-06-16

### Fixed

- Auth to private registry

## \[1.1.0] - 2019-12-31

### Added

- Add contextIgnore parameter to allow excluding content from context.