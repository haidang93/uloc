# Changelog

All notable changes to this project will be documented in this file.

## [1.0.19]

### ✨ Update

- Fix bug

## [1.0.18]

### ✨ Update

- Fix bug

## [1.0.17]

### ✨ Update

- Fix bug

## [1.0.16]

### ✨ Update

- Fix bug

## [1.0.15]

### ✨ Update

- Fix CLI import

## [1.0.14]

### ✨ Update

- Can access to controllers from previous route
- Support type safe parameter

## [1.0.13]

🎉 Initial release!

### ✨ Features

- CLI command: `uloc gen-route` / `uloc gr` to generate routing files from `@ULoCDeclaration`.
- CLI command: `uloc gen-page` / `uloc gp` to scaffold new widget pages with view/controller structure.
- Route declaration default path: `lib/routes/routes.dart`.
- Route target output path: `lib/routes/routes.uloc.g.dart`.
- Support for command-line arguments:
  - `--parameters` to generate route parameters.
  - `--gen-route`, `--route-declaration-dir`, `--route-target-dir`.
- Full support for `dart pub global activate` or in-project via `dart run uloc`.

### 🧪 Usage Examples

```sh
uloc gen-route
uloc gp home
uloc gp book_detail --parameters id,title
```
